package kr.co.peterpet.res.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.peterpet.res.ResBean;
import kr.co.peterpet.res.ResService;
import kr.co.peterpet.util.Page;

@Controller
@RequestMapping("/res")
public class ResClientController {
	@Autowired
	private ResService resService;

	@RequestMapping(value = "/doRes", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> insertRes(ResBean res, @RequestParam String pcode, HttpServletRequest request,
			HttpSession session) throws IOException {
		String uid = (String) session.getAttribute("userId");
		System.out.println("pcode : " + res.getPcode());
		System.out.println("rcount : " + res.getRcount());
		res.setUid(uid);

		res = resService.getSelectInfo(res);
		res.setRcount(Integer.parseInt(request.getParameter("rcount")));
		res.setRtotal(Integer.parseInt(request.getParameter("totalPrice")));
		System.out.println("rcount : " + res.getRcount());
		System.out.println("rtotal : " + res.getRtotal());

		int n = resService.insertResProd(res);

		Map<String, String> result = new HashMap<String, String>();
		if (n > 0) {
			result.put("msg", "success");
		} else {
			result.put("msg", "fail");
		}
		return result;
	}

	@RequestMapping("/checkRes")
	@ResponseBody
	public Map<String, Object> checkRes(ResBean res, @RequestParam String pcode, HttpSession session) {
		String uid = (String) session.getAttribute("userId");
		res.setUid(uid);

		res = resService.getExist(res);

		Map<String, Object> map = new HashMap<String, Object>();
		if (res != null) {
			map.put("exist", "1");
			map.put("rnum", res.getRnum());
			map.put("rcount", res.getRcount());
			map.put("rtotal", res.getRtotal());
		} else {
			map.put("exist", "0");
		}
		System.out.println("resData : " + map.get("exist"));
		return map;
	}
	@PostMapping("/updateRes")
	@ResponseBody
	public Map<String, String> updateRes(ResBean res, HttpSession session) {
		System.out.println("rcount in updateRes : " + res.getRcount());
		System.out.println("rtotal in updateRes : " + res.getRtotal());
		System.out.println("rnum in updateRes : " + res.getRnum());

		int n = resService.updateRes(res);

		Map<String, String> result = new HashMap<String, String>();
		if (n > 0) {
			result.put("msg", "success");
		} else {
			result.put("msg", "fail");
		}
		return result;
	}
	
	

	@RequestMapping(value = "/resList/page/{page}")
	public String getResList(ResBean res, HttpSession session, HttpServletRequest request, @PathVariable String page,
			Model model) throws IOException {
		System.out.println("resList맵핑");
		String uid = (String) session.getAttribute("userId");
		res.setUid(uid);
		int intpage = Integer.parseInt(page);
		int ReserveCount = resService.getReserveCount(uid, "");
		System.out.println("ReserveCount값 :" + ReserveCount);
		Page rpage = new Page(ReserveCount, intpage);
		res.setSearchText("");
		res.setOffset(rpage.getPosts());
		List<ResBean> resList = resService.getResList(res);
		model.addAttribute("resList", resList);
		model.addAttribute("rpage", rpage);
		return "res/list";
	}

	@RequestMapping(value = "/resList/searchText/{searchText}/page/{page}")
	public String getResSearchList(ResBean res, HttpSession session, HttpServletRequest request,
			@PathVariable String searchText, @PathVariable String page, Model model) throws IOException {
		System.out.println("검색 맵핑");
		String uid = (String) session.getAttribute("userId");
		res.setUid(uid);
		int intpage = Integer.parseInt(page);
		System.out.println("searchText값 :" + searchText);
		int ReserveCount = resService.getReserveCount(uid, searchText);
		System.out.println("ReserveCount값 :" + ReserveCount);
		Page rpage = new Page(ReserveCount, intpage);
		System.out.println(rpage.getPosts() + "getpost값");
		res.setSearchText(searchText);
		res.setOffset(rpage.getPosts());
		List<ResBean> resList = resService.getResList(res);
		System.out.println("rpage값 : " + rpage.getStartPage() + "사이" + rpage.getEndPage());
		model.addAttribute("resList", resList);
		model.addAttribute("rpage", rpage);
		model.addAttribute("searchText", searchText);
		return "res/list";
	}

	@RequestMapping(value = "/packageForm", method = RequestMethod.GET)
	public String reserveForm() {
		System.out.println("/res/form맵핑");
		return "res/careForm";
	}

	@RequestMapping(value = "/packageForm/state/{state}", method = RequestMethod.POST)
	public String reserveForm(@ModelAttribute ResBean resBean, @RequestParam("packName") List<String> pack, Model model,
			@PathVariable String state, HttpServletRequest request, HttpSession session) {
		System.out.println("/res/form post 맵핑, resBean, pack = " + resBean + pack);
		String uid = (String) session.getAttribute("userId");
		resBean.setUid(uid);

		if (pack.contains("school")) {
			if (pack.contains("hotel") && pack.contains("beauty")) {
				resBean.setPcode("P111");
			}
			if (pack.contains("hotel")) {
				resBean.setPcode("P110");
			} else if (pack.contains("beauty")) {
				resBean.setPcode("P101");
			} else {
				resBean.setPcode("P100");
			}
		}
		System.out.println(request.getParameter("totalPrice"));
		System.out.println("조건문 아래의 resBean" + resBean);
		System.out.println("resbean의 rnum" + resBean.getRnum());
		ResBean resBean1 = resService.getSelectInfo(resBean);
		resBean1.setRtotal(Integer.parseInt(request.getParameter("totalPrice").replace(",", "")));
		resBean1.merge(resBean);
		if (state.equals("update")) {
			System.out.println("model.getAttribute(\"searchText\")값: " + model.getAttribute("searchText"));
			resService.updatePack(resBean1); // 패키지 업데이트 일때
			model.getAttribute("searchText"); // null로 나옴
		} else {
			resService.reservePackage(resBean1);
		}
		return "redirect:/res/resList/page/1";
	}

	@RequestMapping(value = "/getMyRes/rnum/{rnum}", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, ResBean> getMyRes(@PathVariable String rnum) {
		System.out.println("getMyRes 맵핑성공");
		System.out.println("rnum = " + rnum);
		ResBean myRes = new ResBean();
		int rnum1 = Integer.parseInt(rnum);
		myRes = resService.getMyRes(rnum1);
		Map<String, ResBean> map = new HashMap<String, ResBean>();
		map.put("myRes", myRes);
		System.out.println("/getMyRes맵핑");
		return map;
	}

	@RequestMapping(value = "/packageForm/update/{state}", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> reserveForm(@ModelAttribute ResBean resBean, @RequestParam("packName") List<String> pack,
			@PathVariable String state, HttpServletRequest request, HttpSession session) {
		Map<String, String> result = new HashMap<>();
		System.out.println("pack 내용 : " + pack);
		try {
			String uid = (String) session.getAttribute("userId");
			resBean.setUid(uid);

			if (pack.contains("school")) {
				if (pack.contains("hotel") && pack.contains("beauty")) {
					resBean.setPcode("P111");
				} else if (pack.contains("hotel")) {
					resBean.setPcode("P110");
				} else if (pack.contains("beauty")) {
					resBean.setPcode("P101");
				} else {
					resBean.setPcode("P100");
				}
			}

			ResBean resBean1 = resService.getSelectInfo(resBean);
			resBean1.merge(resBean);
			System.out.println("totalPrice 값 in update : " + request.getParameter("totalPrice"));
			resBean1.setRtotal(Integer.parseInt(request.getParameter("totalPrice")));
			if (state.equals("update")) {
				resService.updatePack(resBean1); // 패키지 업데이트
				result.put("msg", "success");
			} else {
				resService.reservePackage(resBean1); // 패키지 예약
				result.put("msg", "success");
			}
		} catch (Exception e) {
			result.put("msg", "error");
			e.printStackTrace();
		}

		return result;
	}

	@RequestMapping(value = "/updateCount", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> updateResCount(@RequestBody ResBean res) {
		int n = resService.updateRes(res);

		Map<String, String> result = new HashMap<String, String>();
		if (n > 0) {
			result.put("msg", "success");
		} else {
			result.put("msg", "fail");
		}
		System.out.println("msg : " + result.get("msg"));
		return result;
	}

	// 예약 삭제를 처리하는 Controller 메서드
	@RequestMapping(value = "/deleteRes/rnum/{rnum}", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<String> deleteReservation(@PathVariable("rnum") int rnum) {
		try {
			System.out.println("rnum값: ");
			// 예약 삭제 처리 로직
			resService.deleteRes(rnum); // 실제 삭제 서비스 호출
			return ResponseEntity.ok("삭제되었습니다.");
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("삭제 실패");
		}
	}
	
	@RequestMapping(value = "/deleteCartList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> deleteCartList(@RequestBody ResBean res) {
		List<Integer> rnumListInt = new ArrayList<>();
		Map<String, String> map = new HashMap<String, String>();
		if (res.getRnumList() != null && !res.getRnumList().isEmpty()) {
			rnumListInt = res.getRnumList();
			
			int totalDeleted = 0;
			
			for (Integer rnum : rnumListInt) {
		        int result = resService.deleteRes(rnum);
		        totalDeleted += result;
		    }
			
    		if (totalDeleted < 1) {
    			System.out.println("장바구니 예약 삭제 실패");
    			map.put("msg", "fail");
    		}
		}
		map.put("msg", "success");
		return map;
	}

	@RequestMapping(value = "/content", method = RequestMethod.GET)
	public String content(@RequestParam("id") String id) {

		System.out.println("/reserve/form맵핑");
		return "res/careForm";
	}
}
