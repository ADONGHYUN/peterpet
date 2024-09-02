package kr.co.peterpet.user.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.co.peterpet.user.UserBean;
import kr.co.peterpet.user.UserService;
import kr.co.peterpet.user.impl.State;

@Controller
public class LoginController {
	@Autowired
	UserService userService;
	@Autowired
	State sendState;
	
	@GetMapping("/login")
	public String loginView(HttpSession session, Model model) {
		
		// 얘를 손 봐야함
		if(session.getAttribute("userId")!=null) {
			return "redirect:/";
		}
		return "/user/login";
	}

	@PostMapping("/login")
	@ResponseBody
	public String login(HttpSession session, UserBean userBean) {
		if (userService.verify(userBean)) {
			String url = (String) session.getAttribute("url");
			session.removeAttribute("url");
			session.setAttribute("userId", userBean.getUid());
			return (url == null || url.isEmpty()) ? "/" : url;
		} else {
			return "0";
		}
	}

	@PostMapping("/kakaoapi")
	@ResponseBody
	public String getKaAPI() {
		return userService.getKaUrl()+URLEncoder.encode(sendState.ranString(), StandardCharsets.UTF_8);
	}
	
	@PostMapping("/naverapi")
	@ResponseBody
	public String getNaAPI() {
	    return userService.getNaUrl()+URLEncoder.encode(sendState.ranString(), StandardCharsets.UTF_8);
	}
	
	@GetMapping("/kakao-login") 
	public void kakaoLogin(HttpSession session, @RequestParam String code,
							@RequestParam String state,
							@RequestParam(required = false) String error,
							@RequestParam(required = false) String error_description,
							HttpServletResponse response) throws IOException {
		apiLogin(session, code, state, error, error_description, "kakao", response);
	}
	
	@GetMapping("/naver-login")
	@ResponseBody
	public void naverLogin(HttpSession session, @RequestParam String code,
							@RequestParam String state,
							@RequestParam(required = false) String error,
							@RequestParam(required = false) String error_description,
							HttpServletResponse response) throws IOException {
		apiLogin(session, code, state, error, error_description, "naver", response);
	}
	
	private void apiLogin(HttpSession session, String code, String state, String error, String error_description,
            String loginType, HttpServletResponse response) throws IOException {
		if (error == null && sendState.stateEquals(state)) {
			// 의미는 없지만 객체 재사용 여기부터는 id로 바뀜
			loginType = "naver".equals(loginType) ? userService.naVerify(code) : userService.kaVerify(code);
	        if (loginType != null) {
	            session.setAttribute("userId", loginType);
	            String url = (String) session.getAttribute("url");
				session.removeAttribute("url");
	            response.setContentType("text/html");
	            PrintWriter out = response.getWriter();
	            out.println("<html><body>");
	            out.println("<script>");
	            out.println("window.opener.location.replace(" + (url == null || url.isEmpty() ? "'/'" : "'" + url + "'") + ");");
	            out.println("window.close();");
	            out.println("</script>");
	            out.println("</body></html>");
	            return;
	        }
	    } else {
	        System.out.println("Error Code: " + error + "\n" + "ErrorMessage : " + error_description);
	        System.out.println("위 에러가 Null이라면 State가 다르다는 의미입니다. ");
	    }
	    response.setContentType("text/html");
	    PrintWriter out = response.getWriter();
	    out.println("<html><body>");
	    out.println("<script>");
	    out.println("alert('로그인을 실패했습니다. 문의 주세요.');");
	    out.println("window.close();");
	    out.println("</script>");
	    out.println("</body></html>");
	}
	
	@RequestMapping(value = "/admin", method = RequestMethod.GET)
	public String admin(HttpSession session, HttpServletResponse response) throws IOException {
		// userId가 admin인지 확인
		String id = (String) session.getAttribute("userId");
	    if (id.equals("admin")) {
	        // admin이면 /admin/user/index로 리디렉션
	        return "redirect:/admin/user/index"; // 리디렉션을 처리한 후 반환값을 null로 설정
	    } else {
	    	return "redirect:/";
	    }
	}
	
	// Admin
		@RequestMapping(value = "/admin/login", method = RequestMethod.GET)
		public String adminLogin(HttpSession session, HttpServletResponse response) throws IOException {
		    // 세션에서 userId를 가져옴
			String id = (String) session.getAttribute("userId");
		    if (id == null) {    
		        return "admin/index"; // 리디렉션을 처리한 후 반환값을 null로 설정
		    } else if (id.equals("admin")) {
		    	return "redirect:/admin/user/index";
		    } else {
		        return "redirect:/"; // 리디렉션을 처리한 후 반환값을 null로 설정
		    }
		}

	@RequestMapping(value = "/admin/login", method = RequestMethod.POST)
	public String login(UserBean vo, HttpSession session, Model model) {
	    // 아이디와 비밀번호가 입력되지 않았을 경우 예외 발생
	    if (vo.getUid() == null || vo.getUid().trim().isEmpty()) {
	        model.addAttribute("errorMessage", "아이디를 입력해주세요.");
	        model.addAttribute("redirectUrl", "/admin/login");
	        return "admin/index"; // 에러 메시지와 함께 로그인 페이지로 포워딩
	    }
	    if (vo.getUpw() == null || vo.getUpw().trim().isEmpty()) {
	        model.addAttribute("errorMessage", "비밀번호를 입력해주세요.");
	        model.addAttribute("redirectUrl", "/admin/login");
	        return "admin/index"; // 에러 메시지와 함께 로그인 페이지로 포워딩
	    }

	    // 사용자 정보 조회
	    UserBean user = userService.getUser(vo.getUid());

	    if (user == null) {
	        // 데이터베이스에 아이디가 없을 때
	        model.addAttribute("errorMessage", "아이디가 존재하지 않습니다.");
	        model.addAttribute("redirectUrl", "/admin/login");
	        return "admin/index"; // 에러 메시지와 함께 로그인 페이지로 포워딩
	    } else if ("admin".equals(user.getUid())) {
	        // 'admin' 아이디가 맞는 경우
	        session.setAttribute("userId", user.getUid());
	        return "redirect:/admin/user/index"; // 로그인 페이지로 포워딩
	    } else {
	        // 'admin' 아이디가 아닌 경우
	        model.addAttribute("errorMessage", "회원전용 로그인으로 이동하겠습니다");
	        model.addAttribute("redirectUrl", "/login"); // 일반 사용자 페이지로 리디렉션 URL
	        return "admin/index"; // 로그인 페이지로 포워딩
	    }
	}
}