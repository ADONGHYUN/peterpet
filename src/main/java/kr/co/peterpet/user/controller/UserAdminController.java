package kr.co.peterpet.user.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.peterpet.prod.ProdChartBean;
import kr.co.peterpet.prod.ProdService;
import kr.co.peterpet.res.ResService;
import kr.co.peterpet.user.UserBean;
import kr.co.peterpet.user.UserService;

@Controller
@RequestMapping("/admin/user/")
public class UserAdminController {
	@Autowired
	private UserService userService;
	@Autowired
	private ResService resService;
	@Autowired
	private ProdService prodService;
	
	

	@RequestMapping(value = "getlist/{page}/{searchCondition}", method = RequestMethod.GET)
	public String list(
	        @PathVariable("page") String pageStr,
	        @PathVariable("searchCondition") String searchCondition,
	        @RequestParam(value = "searchKeyword", defaultValue = "") String searchKeyword,
	        Model model) {

	    try {
	        String encodedSearchKeyword = URLEncoder.encode(searchKeyword, "UTF-8");
	        System.out.println(encodedSearchKeyword + "aaaaaaaa");
	    } catch (UnsupportedEncodingException e) {
	        e.printStackTrace(); // 예외 처리
	    }

	    int page;
	    try {
	        page = Integer.parseInt(pageStr);
	    } catch (NumberFormatException e) {
	        page = 1; // 기본값 설정
	    }

	    if (searchCondition == null || searchCondition.isEmpty()) {
	        searchCondition = "uname"; // 기본값 설정
	    }

	    int limit = 10;  // 한 페이지에 보여줄 데이터 수
	    int offset = (page - 1) * limit;  // OFFSET 계산

	    UserBean vo = new UserBean();
	    vo.setPage(page);
	    vo.setLimit(limit);
	    vo.setOffset(offset);  // OFFSET 설정
	    vo.setSearchCondition(searchCondition);
	    vo.setSearchKeyword(searchKeyword);

	    List<UserBean> user = userService.getUserList(vo);
	    int listCount = userService.getListCount(vo);
	    int maxPage = (int) ((double) listCount / limit + 0.95);
	    int startPage = (((int) ((double) (page - 1) / 5)) * 5 + 1);
	    int endPage = startPage + 5 - 1;
	    if (endPage > maxPage) endPage = maxPage;

	    vo.setStartPage(startPage);
	    vo.setMaxPage(maxPage);
	    vo.setEndPage(endPage);

	    model.addAttribute("user", user);
	    model.addAttribute("vo", vo);

	    return "admin/user/userlist";
	}





	@RequestMapping(value = "getlistAjax/{page}/{searchCondition}", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> listAjax(
	        @PathVariable("page") int page,
	        @PathVariable("searchCondition") String searchCondition,
	        @RequestParam(value = "searchKeyword", defaultValue = "") String searchKeyword) {

	    // 디버깅용 로그 출력
	    System.out.println(searchKeyword + "aaaaaaaa");

	    int limit = 10;  // 페이지당 데이터 수
	    int offset = (page - 1) * limit;  // OFFSET 계산

	    UserBean vo = new UserBean();
	    vo.setPage(page);
	    vo.setLimit(limit);
	    vo.setOffset(offset);  // OFFSET 설정
	    vo.setSearchCondition(searchCondition);
	    vo.setSearchKeyword(searchKeyword);

	    List<UserBean> user = userService.getUserList(vo);
	    int listCount = userService.getListCount(vo);

	    int maxPage = (int) ((double) listCount / limit + 0.95);
	    int startPage = (((int) ((double) (page - 1) / 5)) * 5 + 1);
	    int endPage = startPage + 5 - 1;
	    if (endPage > maxPage) endPage = maxPage;

	    vo.setStartPage(startPage);
	    vo.setMaxPage(maxPage);  
	    vo.setEndPage(endPage);

	    Map<String, Object> response = new HashMap<>();
	    response.put("user", user);
	    response.put("vo", vo);

	    return response;
	}




	@RequestMapping(value = "index", method = RequestMethod.GET)
	public String index(Model model, UserBean vo) {
	    List<Map<String, Object>> user = userService.getChart1(vo);
	    List<Map<String, Object>> user1 = userService.getChart2(vo);
	    ProdChartBean chartBean = prodService.getChart();
		ProdChartBean chartBean2 = prodService.getPtype();
	    int UserCount = userService.getUserCount(vo);
	    System.out.println(chartBean2.getPtype1()+"a"+chartBean2.getPtype1()+"b"+chartBean2.getPtype2()+" count값");
		System.out.println(chartBean.getCount1()+"a"+chartBean.getCount2()+"b"+chartBean.getCount3()+" count값");
	    System.out.println("User List: " + user);
	    System.out.println("User gender: " + user1);
	    System.out.println("Userlist: " + UserCount);
	    String genderDataString = user1.stream()
	            .map(map -> String.format("{\"gender_label\": \"%s\", \"count\": %d}", map.get("gender_label"), map.get("count")))
	            .collect(Collectors.joining(",", "[", "]"));

	    String userListString = user.stream()
	            .map(map -> String.format("{\"age_range\": \"%s\", \"user_count\": %d}", map.get("age_range"), map.get("user_count")))
	            .collect(Collectors.joining(",", "[", "]"));

	    // 데이터 추가
	  
		model.addAttribute("chartBean", chartBean);
		model.addAttribute("chartBean2", chartBean2);
	    model.addAttribute("userListString", userListString);
	    model.addAttribute("genderDataString", genderDataString);
	    model.addAttribute("UserCount", UserCount);
	    return "admin/user/adminindex";
	}

	@RequestMapping(value = "insert", method = RequestMethod.GET)
	public String insert() {
	    return "admin/user/userinsert";
	}

	@RequestMapping(value = "insert", method = RequestMethod.POST)
	public String insert(@ModelAttribute("user") UserBean vo) {
	    // addr2가 null인 경우 처리
	    String fullAddr;
	    if (vo.getAddr2() == null || vo.getAddr2().trim().isEmpty()) {
	        // addr2가 null이거나 빈 문자열일 경우
	        fullAddr = vo.getAddr();
	    } else {
	        // addr2가 존재할 경우
	        fullAddr = vo.getAddr() + "," + vo.getAddr2();
	    }
	    
	    // 결합된 주소를 설정
	    vo.setAddr(fullAddr);
	    
	    // 사용자 정보를 데이터베이스에 저장
	    userService.adInsert(vo);
	    
	    // 리다이렉트
	    return "redirect:/admin/user/getlist";
	}
	
	@RequestMapping(value = "update/{page}/{searchCondition}", method = RequestMethod.POST)
	public String update(
	        @ModelAttribute("user") UserBean vo,
	        @PathVariable("page") int page,
	        @PathVariable("searchCondition") String searchCondition,
	        @RequestParam(value = "searchKeyword", defaultValue = "") String searchKeyword) {

	    System.out.println(vo.getAddr2());

	    String fullAddr1;
	    if (vo.getAddr2() == null || vo.getAddr2().trim().isEmpty()) {
	        // addr2가 null이거나 빈 문자열일 경우
	        fullAddr1 = vo.getAddr();
	    } else {
	        // addr2가 존재할 경우
	        fullAddr1 = vo.getAddr() + "," + vo.getAddr2();
	        vo.setAddr(fullAddr1);
	    }

	    userService.adUpdate(vo);

	    // URL 경로를 쿼리 파라미터로 생성
	    String encodedSearchCondition = URLEncoder.encode(searchCondition, StandardCharsets.UTF_8);
	    String encodedSearchKeyword = URLEncoder.encode(searchKeyword, StandardCharsets.UTF_8);

	    return "redirect:/admin/user/getlist/" + page + "/" + encodedSearchCondition + "?searchKeyword=" + encodedSearchKeyword;
	}


	
	@ModelAttribute("conditionMap")
	public Map<String, String> searchConditionMap() {
		Map<String, String> conditionMap = new HashMap<String, String>();
		conditionMap.put("아이디", "uid");
		conditionMap.put("이름", "uname");
		return conditionMap;
	}
	
	
	@RequestMapping(value = "delete/{userId}/{page}/{searchCondition}", method = RequestMethod.GET)
	public String delete(
	        @PathVariable("userId") String userId,
	        @PathVariable("page") int page,
	        @PathVariable("searchCondition") String searchCondition,
	        @RequestParam(value = "searchKeyword", defaultValue = "") String searchKeyword,
	        UserBean vo) {

	    // 사용자와 관련된 데이터 삭제
		vo.setUid(userId);
	    resService.delete(vo.getUid());
	    vo.setUid(userId);
	    userService.delete(vo.getUid());
	   

	 

	    // 리다이렉트 URL 생성
	    return "redirect:/admin/user/getlist/" + page + "/" + searchCondition + "?searchKeyword=" + searchKeyword;
	}




	
	
	@RequestMapping(value = "getdetail/{uid}/{page}/{searchCondition}", method = RequestMethod.GET)
	public String detail(
	        @PathVariable("uid") String uid,
	        @PathVariable("page") int page,
	        @PathVariable("searchCondition") String searchCondition,
	        @RequestParam(value = "searchKeyword", defaultValue = "") String searchKeyword,
	        UserBean vo,
	        Model model) {

	    // UID와 검색 조건을 UserBean 객체에 설정
	    vo.setUid(uid);
	    vo.setPage(page);
	    vo.setSearchCondition(searchCondition);
	    vo.setSearchKeyword(searchKeyword);
	    System.out.println(vo.getUid());

	    // UID를 사용하여 사용자 정보 조회
	    UserBean user = userService.getUser(vo.getUid());

	    model.addAttribute("user", user);
	    model.addAttribute("vo", vo);

	    return "admin/user/userdetail";
	}



	@RequestMapping(value = "checkEmail", method = RequestMethod.POST)
	public ResponseEntity<String> checkEmail(@RequestParam("email") String email) {
	    System.out.println(email);
	    int emailExists = userService.getmail(email);
	    System.out.println(emailExists);
	    if (emailExists > 0) {  // 이메일이 하나라도 존재하면 중복된 것으로 간주
	        return ResponseEntity.ok("exists");
	    } else {
	        return ResponseEntity.ok("available");
	    }
	}

	
	@RequestMapping(value = "/checkid", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> checkId(@RequestParam("uid") String uid) {
	    Map<String, Object> response = new HashMap<>();
	    response.put("result", userService.getUser(uid)==null ? 0 : 1);
	    return ResponseEntity.ok(response);
	}
}