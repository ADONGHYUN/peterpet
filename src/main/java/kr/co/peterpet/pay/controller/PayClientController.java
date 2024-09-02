package kr.co.peterpet.pay.controller;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.peterpet.pay.PayBean;
import kr.co.peterpet.pay.PayService;
import kr.co.peterpet.res.ResBean;
import kr.co.peterpet.res.ResService;
import kr.co.peterpet.user.UserBean;
import kr.co.peterpet.user.UserService;


@Controller
@RequestMapping("/pay")
public class PayClientController {
	
	@Autowired
	private ResService resService;
	
	@Autowired
	private PayService payService;
	
	@Autowired
	private UserService userService;
	
	private final HttpClient httpClient = HttpClient.newHttpClient();
	
	@Value("${portone.api.secret}")
	private String apiSecret;
	
	private final ObjectMapper objectMapper = new ObjectMapper();
	
	@PostMapping("/doOrder")
	public String payForm(ResBean res1, @RequestParam String pcode,
			HttpServletRequest request, HttpSession session, Model model) {
		String uid = (String) session.getAttribute("userId");
		System.out.println("rtotal in pay: " + res1.getRtotal());
		
		res1.setUid(uid);
		ResBean res = resService.getSelectInfo(res1);
		res.merge(res1);
		res.setRcount(Integer.parseInt(request.getParameter("count")));
		model.addAttribute("res", res);
		
		return "pay/detailPagePay";
	}
	
	@PostMapping("/goResPay")
	public String getOrderPage(@RequestParam List<Integer> rnumList, HttpSession session, Model model) {
		
		String uid = (String)session.getAttribute("userId");
		List<ResBean> res = resService.getChooseRes(rnumList);
		
		UserBean user = userService.getUser(uid);
		int totalAmount = res.stream().mapToInt(ResBean::getRtotal).sum();
		
		model.addAttribute("res", res );
		model.addAttribute("user", user);
		model.addAttribute("totalAmount", totalAmount);
		
		return "pay/orderList";
	}
	
	@PostMapping("/insertKakaoPay")
    @ResponseBody
	public Map<String, Object> insertPayProd(@RequestBody List<PayBean> payBean) {
    	System.out.println(payBean.get(0).getPaymentId());
    	List<Integer> rnumList2 = payBean.stream()
    			.flatMap(bean -> bean.getRnumList().stream()) // 각 PayBean 객체의 rnumList를 스트림으로 변환
                .collect(Collectors.toList()); // 스트림을 List<Integer>로 수집
    	
    	int totalInserted = 0;
    	
    	for (PayBean pay : payBean) {
	        int result = payService.insertPayProd(pay);
	        totalInserted += result;
	    }
    	
		System.out.println("insert된 데이터 줄 수: " + totalInserted);
		
		Map<String, Object> result = new HashMap<>();
	    result.put("insert", totalInserted);
	    result.put("rnumList", rnumList2);
	    System.out.println("insert 후 result: " + result);
	    System.out.println("result.get('rnumList'): " + result.get("rnumList"));
		return result;
	}
	
	@PostMapping("/complete")
	@ResponseBody
	public ResponseEntity<String> payComplete(@RequestBody PayBean pay) {

		System.out.println("pay 출력: " + pay.getPaymentId() + pay.getTransactionType() + pay.getTxId() + pay.getCode() + pay.getStatus());
		System.out.println("@RequestBody로 받은 rnumList: " + pay.getRnumList());
		
		List<Integer> rnumListInt = new ArrayList<>();
		
		if (pay.getRnumList() != null && !pay.getRnumList().isEmpty()) {
			rnumListInt = pay.getRnumList();
		}
		
		System.out.println("주문번호: " + pay.getPaymentId());

		Map<String, String> responseBody = new HashMap<>();
		
		try {
			String paymentId = pay.getPaymentId();
			
            System.out.println(apiSecret);
			HttpRequest request = HttpRequest.newBuilder()
				    .uri(URI.create("https://api.portone.io/payments/" + paymentId))
				    .header("Content-Type", "application/json")
				    .header("Authorization", "PortOne " + apiSecret)
				    .GET()
				    .build();
			
			HttpResponse<String> response = HttpClient.newHttpClient().send(request, HttpResponse.BodyHandlers.ofString());
			String jsonResponse = response.body();
			System.out.println(response.body());
			
			int status = response.statusCode();
			
			if (status >= 200 && status < 300) {
				
				JsonNode jsonNode = objectMapper.readTree(jsonResponse);
				String paymentStatus = jsonNode.get("status").asText();
                System.out.println("Payment Status: " + paymentStatus);

                int totalAmount = jsonNode.get("amount").get("total").asInt();
                
                System.out.println("totalAmount: " + totalAmount);
                
                int order = payService.findAmount(paymentId);

                	if (order == totalAmount) {
                        // 결제 상태에 따라 로직 처리
                        switch (jsonNode.get("status").asText()) {
                            case "PAID":
                                // 결제 완료 로직
                        		int n = payService.updatePayStatus(pay);
                        		
                        		if (n < 1) {
                        			System.out.println("결제 상태 수정 실패");
                        		}
                        		
                        		if (pay.getRnumList() != null && !pay.getRnumList().isEmpty()) {
                        			
                        			int totalDeleted = 0;
                        			
                        			for (Integer rnum : rnumListInt) {
                        		        int result = resService.deleteRes(rnum);
                        		        totalDeleted += result;
                        		    }
                        			
                            		if (totalDeleted < 1) {
                            			System.out.println("장바구니 예약 삭제 실패");
                            		}
                        		}
                        		
                        		return ResponseEntity.status(HttpStatus.OK).body("결제 완료 처리. Payment verified successfully.");
                            default:
                        		return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("결제 예외 처리. Unhandled payment status");
                        }
                    } else {
                        // 결제 금액 불일치
                    	responseBody.put("결제 금액 불일치", "Payment amount mismatch.");
                        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("결제 금액 불일치. Payment amount mismatch.");
                    }
			} else {
				System.out.println("HTTP error code: " + status);
				return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("결제 검증 요청 실패. Failed to fetch payment details");
			}
			
		} catch (Exception e) {
			//결제 검증 실패
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Error: " + e.getMessage());
		}
	}
	
	@PostMapping("/insertKcp")
	@ResponseBody
	public Map<String, String> insertPay(PayBean pay, @RequestParam String paymentId, 
			HttpSession session) throws IOException{
		String uid = (String) session.getAttribute("userId");
		pay.setUid(uid);
		pay.setOrderName(pay.getPname());
		pay.setTotalAmount(pay.getRtotal());
		
		int n = payService.insertPay(pay);
		
		Map<String, String> result = new HashMap<String, String>();
		if (n > 0) {
			result.put("msg", "success");
		} else {
			result.put("msg", "fail");
		}
		return result;
	}
	
	@PostMapping("/insertKcplist")
	@ResponseBody
	public Map<String, String> insertOrders(@RequestBody List<PayBean> payload, HttpSession session, Model model) throws IOException{
		String uid = (String) session.getAttribute("userId");
		Map<String, String> result = new HashMap<>();
		
		if (payload.isEmpty()) {
            result.put("msg", "fail");
            return result;
        }
		
		String firstItemName = payload.get(0).getPname();
        int otherItemCount = payload.size() - 1;
        String orderName = otherItemCount > 0 ? firstItemName + " 외 " + otherItemCount + "개" : firstItemName;
        
        try {
            for (PayBean pay : payload) {
                pay.setUid(uid);
                pay.setOrderName(orderName);

                int n = payService.insertPayProd(pay); // 각 주문 데이터 삽입

                if (n <= 0) {
                    result.put("msg", "fail");
                    return result; // 삽입 실패 시 응답 반환
                }
            }
            result.put("msg", "success");
            result.put("orderName", orderName);
        } catch (Exception e) {
            result.put("msg", "fail");
            e.printStackTrace();
        }
        model.addAttribute("orderName" , orderName);
        System.out.println("ordName : " + model.getAttribute("orderName"));
        return result;
	}
	
	@PostMapping("/failPay")
	@ResponseBody
	public Map<String, String> failPay(PayBean pay, @RequestParam String paymentId, 
			HttpSession session) throws IOException{
		String uid = (String) session.getAttribute("userId");
		pay.setUid(uid);
		
		System.out.println("code 값 : " + pay.getCode());
		
		int n = payService.deleteByPaymentId(paymentId);
		
		Map<String, String> result = new HashMap<String, String>();
		if (n > 0) {
			result.put("msg", "success");
		} else {
			result.put("msg", "fail");
		}
		return result;
	}
	
	@PostMapping("/kcpcomplete")
    public ResponseEntity<String> kcpPayComplete(@RequestBody PayBean pay) throws Exception {
		List<Integer> rnumListInt = new ArrayList<>();
		
		if (pay.getRnumList() != null && !pay.getRnumList().isEmpty()) {
			rnumListInt = pay.getRnumList();
		}

		ObjectMapper objectMapper = new ObjectMapper();
		try {
            // 1. 포트원 결제내역 단건조회 API 호출
            HttpRequest httpRequest = HttpRequest.newBuilder()
                .uri(new URI("https://api.portone.io/payments/" + pay.getPaymentId()))
                .header("Authorization", "PortOne " + apiSecret)
                .GET()
                .build();

            HttpResponse<String> response = httpClient.send(httpRequest, HttpResponse.BodyHandlers.ofString());
            
            if (response.statusCode() != 200) {
                throw new RuntimeException("Failed to get payment details: " + response.statusCode());
            }
            
            JsonNode paymentNode = objectMapper.readTree(response.body());
            
            JsonNode amountNode = paymentNode.path("amount");
            JsonNode totalNode = amountNode.path("total");
            int paymentAmount = totalNode.asInt();
            String paymentStatus = paymentNode.path("status").asText();
            
            int totalAmount = payService.findAmount(pay.getPaymentId());
            
            if(totalAmount == paymentAmount) {
            	switch (paymentStatus) {
                case "PAID":
                    System.out.println("결제 상태 : " + paymentStatus);
                    pay.setStatus("결제완료");
                    if (pay.getRnumList() != null && !pay.getRnumList().isEmpty()) {
            			
            			int totalDeleted = 0;
            			
            			for (Integer rnum : rnumListInt) {
            		        int result = resService.deleteRes(rnum);
            		        totalDeleted += result;
            		    }
            			
                		if (totalDeleted < 1) {
                			System.out.println("장바구니 예약 삭제 실패");
                		}
            		}
                    break;
                case "FAILED":
                	System.out.println("결제 상태 : " + paymentStatus);
                	pay.setStatus("결제취소");
                	break;
                default:
                	System.out.println("기타 결제 상태 : " + paymentStatus);
                    break;
            	}
            	payService.updatePayStatus(pay);
            } else {
            	return ResponseEntity.badRequest().body("Amount mismatch detected.");
            }
            
            return ResponseEntity.ok("Payment processed successfully");
		} catch (IOException e) {
            // JSON 처리에 실패했습니다.
            return ResponseEntity.badRequest().body("JSON processing failed: " + e.getMessage());
        } catch (Exception e) {
            // 결제 검증에 실패했습니다.
            return ResponseEntity.badRequest().body("Payment verification failed: " + e.getMessage());
        }
    }
	
	@GetMapping("/getPayDetail/{paymentId}")
	public String getPayDetail (@PathVariable String paymentId, PayBean pay, HttpSession session, Model model) {
		List<PayBean> paidList = payService.getPayDetail(paymentId);
		System.out.println("pimg1값 in payDetail : " + paidList.get(0).getPimg1());
		model.addAttribute("paidList", paidList);
		
		return "pay/payDetail";
	}
	
	@GetMapping("/mypaylist")
	public String mypaylist(HttpSession session, Model model) {
		String uid = (String) session.getAttribute("userId");
		List<PayBean> paylist = payService.getMypayList(uid);
		System.out.println(paylist);
		model.addAttribute("payList", paylist);
		return "pay/mypaylist";
	}
		@GetMapping("/bestProdList")
		@ResponseBody
		public List<PayBean> getBestProdList() {
			List<PayBean> bestProdList = payService.getBestProdList();
			System.out.println(bestProdList);

			return bestProdList;
		}
	
}