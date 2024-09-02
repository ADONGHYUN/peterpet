package kr.co.peterpet.res.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.peterpet.prod.ProdBean;
import kr.co.peterpet.prod.ProdService;
import kr.co.peterpet.res.ResBean;
import kr.co.peterpet.res.ResService;
import kr.co.peterpet.user.UserBean;
import kr.co.peterpet.user.UserService;

@Controller
@RequestMapping("/admin/res")
public class ResAdminController {
	@Autowired
	private ResService resService;
	@Autowired
	private ProdService prodService;
	@Autowired
	private UserService userService;
	
	@RequestMapping("/list")
	public String getResList(ResBean res, Model model) {
		System.out.println("예약관리 화면으로 이동");
		model.addAttribute("resList", resService.getAdResList(res));
		return "admin/res/list";
	}
	
	@GetMapping("/insertResProd")
	public String insertFormProd() {
		System.out.println("상품 예약 등록 화면으로 이동");
		return "admin/res/insertFormProd";
	}
	
	@PostMapping("/insertResProd")
	public String insertResProd(@ModelAttribute ResBean res) throws IOException {
		System.out.println("예약 등록 진행...");
		
		if (res.getAddr2() != null && !res.getAddr2().trim().isEmpty()) {
			res.setAddr(res.getAddr() + ", " + res.getAddr2());
		}
		
		System.out.println("res에 저장된 Addr: " + res.getAddr());
		resService.insertResProd(res);
		return "redirect:/admin/res/list";
	}
	
	@GetMapping("/insertResPack")
	public String insertFormPack() {
		System.out.println("패키지 예약 등록 화면으로 이동");
		return "admin/res/insertFormPack";
	}
	
	@PostMapping("/insertResPack")
	public String insertResPack(@ModelAttribute ResBean res) throws IOException {
		System.out.println("예약 등록 진행...");
		
		resService.insertResPack(res);
		return "redirect:/admin/res/list";
	}
	
	@RequestMapping("/detail/rnum/{rnum}")
	public String getRes(@PathVariable int rnum, Model model) {
		System.out.println("예약 상세 화면으로 이동");
		ResBean res = new ResBean();
		res.setRnum(rnum);
		
		ResBean rb = resService.getRes(res);
		
		// 주소를 쉼표로 나누기 전에 null 체크 및 빈 문자열 처리
        String address = rb.getAddr();
        if (address != null && !address.trim().isEmpty()) {
            String[] addr = address.split(", ", 2);
            if (addr.length > 1) {
            	rb.setAddr(addr[0].trim());
            	rb.setAddr2(addr[1].trim());
            } else {
            	rb.setAddr(addr[0].trim());
            	rb.setAddr2(""); // 두 번째 주소가 없으므로 빈 문자열로 설정
            }
        } else {
            // 주소가 null이거나 빈 문자열인 경우 기본 처리
        	rb.setAddr("");
        	rb.setAddr2("");
        }
        
		model.addAttribute("res", rb); // Model 정보 저장
		
		return "admin/res/detail";
	}
	
	@GetMapping("/updateRes/rnum/{rnum}")
	public String updateForm(@PathVariable int rnum, Model model) throws IOException {
		ResBean res = new ResBean();
		res.setRnum(rnum);
		
		ResBean rb = resService.getRes(res);
		
		// 주소를 쉼표로 나누기 전에 null 체크 및 빈 문자열 처리
        String address = rb.getAddr();
        if (address != null && !address.trim().isEmpty()) {
            String[] addr = address.split(", ", 2);
            if (addr.length > 1) {
            	rb.setAddr(addr[0].trim());
            	rb.setAddr2(addr[1].trim());
            } else {
            	rb.setAddr(addr[0].trim());
            	rb.setAddr2(""); // 두 번째 주소가 없으므로 빈 문자열로 설정
            }
        } else {
            // 주소가 null이거나 빈 문자열인 경우 기본 처리
        	rb.setAddr("");
        	rb.setAddr2("");
        }
        
		model.addAttribute("res", rb); // Model 정보 저장
		
		return "admin/res/updateForm";
	}
	
	@PostMapping("/updateRes/rnum/{rnum}")
	public String updateRes(@PathVariable int rnum, @ModelAttribute ResBean res) {
		System.out.println("예약 수정 진행...");
		
	
		if (res.getAddr2() != null && !res.getAddr2().trim().isEmpty()) {
			res.setAddr(res.getAddr() + ", " + res.getAddr2());
		}
		
		resService.updateAdRes(res);
		return "redirect:/admin/res/detail/rnum/" + rnum;
	}
	
	@GetMapping("/deleteRes/rnum/{rnum}")
	public String deleteRes(@PathVariable("rnum") int rnum) {
		System.out.println("예약 삭제");
		resService.deleteRes(rnum);
		return "redirect:/admin/res/list";
	}
	
	@GetMapping("/getProdListbyPtype")
	@ResponseBody
	public List<ProdBean> getProdListbyPtype(@RequestParam String ptype) {
        System.out.println("상품 종류 확인 및 상품 리스트 가져오기");
        System.out.println("prod의 ptype: " + ptype);

        ProdBean prod = new ProdBean();
        prod.setPtype(ptype);

        List<ProdBean> pb = prodService.getProdListbyPtype(prod);
        
        return pb;
    }
	
	@GetMapping("/getProdInfo")
	@ResponseBody
	public ProdBean getProdInfo(@RequestParam String pcode) {
        System.out.println("상품 코드 확인 및 상품 정보 가져오기");
        System.out.println("prod의 pcode: " + pcode);

        ProdBean prod = new ProdBean();
        prod.setPcode(pcode);
        
        return prodService.getProd(prod); // Bean 객체 반환 시 spring이 JSON으로 변환함.
    }
	
	@GetMapping("/idCheck")
	@ResponseBody
	public UserBean getUserInfo(@RequestParam String uid) {
        System.out.println("고객 아이디 확인 및 고객 정보 가져오기");

        UserBean ub = userService.getUser(uid);
        // 주소를 쉼표로 나누기 전에 null 체크 및 빈 문자열 처리
        String address = ub.getAddr();
        if (address != null && !address.trim().isEmpty()) {
            String[] addr = address.split(", ", 2);
            if (addr.length > 1) {
                ub.setAddr(addr[0].trim());
                ub.setAddr2(addr[1].trim());
            } else {
                ub.setAddr(addr[0].trim());
                ub.setAddr2(""); // 두 번째 주소가 없으므로 빈 문자열로 설정
            }
        } else {
            // 주소가 null이거나 빈 문자열인 경우 기본 처리
            ub.setAddr("");
            ub.setAddr2("");
        }
        
        return ub;
    }
}
