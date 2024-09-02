package kr.co.peterpet.user.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import kr.co.peterpet.res.ResService;
import kr.co.peterpet.user.UserBean;
import kr.co.peterpet.user.UserService;

@Controller
@RequestMapping("/user/")
@SessionAttributes("userId")
public class UserClientController {
	@Autowired
	private UserService userService;
	@Autowired
	private ResService resService;

	@RequestMapping(value = "/join/getId", method = RequestMethod.POST)
	@ResponseBody
	public String getId(String uid) {
		if (userService.getID(uid)) {
			return "yes";
		}
		return "no";
	}

	@GetMapping("join")
	public String join(HttpSession session) {
		if(session.getAttribute("userId")!=null) {
			String str = "redirect:/";
			return str;
		}
		return "/user/join";
	}

	@RequestMapping(value = "/join", method = RequestMethod.POST)
	@ResponseBody
	public String join(@RequestBody UserBean user) {
		System.out.println("회원가입하기");
		user.setAddr(user.getAddr() + "," + user.getAddr2());
		System.out.println(user);
		int success = userService.insertUser(user);
		if (success > 0) {
			System.out.println("성공");
			return "yes";
		}
		System.out.println("실패");
		return "no";
	}

	@RequestMapping(value = "/findId", method = RequestMethod.GET)
	public String toIdFind() {
		System.out.println("아이디찾기폼으로");
		return "/user/findId";
	}

	@RequestMapping(value = "/findPw", method = RequestMethod.GET)
	public String toPwFind() {
		System.out.println("비밀번호찾기폼으로");
		return "/user/findPw";
	}
	
	@RequestMapping(value = "/join/getMail", method = RequestMethod.POST)
	@ResponseBody
	public String getMail(String uemail) {
		System.out.println(uemail);
		String user = userService.getSameMail(uemail);
		if (user != null) {
			return "yes";
		}
		return "no";
	}
	
	@RequestMapping(value = "/findGetMail", method = RequestMethod.POST)
	@ResponseBody
	public String getIdFind(@RequestParam String uemail) throws Exception {
		System.out.println("입력받은 이메일: " + uemail);
		return userService.getMail(uemail);
	}

	@RequestMapping(value = "/findId", method = RequestMethod.POST)
	@ResponseBody
	public String getIdFindCode(@RequestBody UserBean user) {

		System.out.println("아이디 찾기");
		System.out.println(user);

		return userService.getMailCode(user);
	}

	@RequestMapping(value = "/findIdResult", method = RequestMethod.POST)
	public String toFindIdResult(String uemail, Model model) throws Exception {
		System.out.println("이메일: " + uemail);
		UserBean list = userService.getFindId(uemail);
		model.addAttribute("userList", list);
		return "/user/findIdResult";
	}

	@RequestMapping(value = "/findGetFid", method = RequestMethod.POST)
	@ResponseBody
	public String getPwFind(@RequestParam String uid, @RequestParam String uemail) throws Exception {
		System.out.println("입력받은 아이디: " + uid);
		System.out.println("입력받은 이메일: " + uemail);
		return userService.getFid(uid,uemail);
	}
	
	@RequestMapping(value = "/findPw", method = RequestMethod.POST)
	@ResponseBody
	public String getPwFindCode(@RequestBody UserBean user) {

		System.out.println("패스워드 찾기");
		System.out.println(user);

		return userService.getMailCodePw(user);
	}

	@RequestMapping(value = "/findPwResult", method = RequestMethod.POST)
	public String toFindPwResult(String uid, Model model) throws Exception {
		System.out.println("아이디: " + uid);
		String conf = userService.getFindPw(uid);
		if(conf.equals("yes")) {
			model.addAttribute("uid", uid);
		}
		return "/user/findPwResult";
	}
	
	@RequestMapping(value = "/findPwChange", method = RequestMethod.POST)
	@ResponseBody
	public String pwChange(@RequestBody UserBean user) {

		System.out.println("비밀번호 찾기/변경");
		System.out.println(user);

		return userService.pwChange(user);
	}
	
	// 내정보
	@GetMapping("myInfo")
	public String myInfo(@ModelAttribute("userId") String userId, Model model) {
		UserBean userBean = userService.getUser(userId);
		if(userBean!=null) {
			ObjectMapper objectMapper = new ObjectMapper();
			ObjectNode node = objectMapper.createObjectNode();
			if (userBean.getKapi() != null) {
				node.put("kakao", 1);
			} 
			if (userBean.getNapi() != null) {
				node.put("naver", 1);
			} 
			if (userBean.getUid().length() <= 12) {
				node.put("id", 1);
			}
			model.addAttribute("type", node.toString());
			model.addAttribute("myinfo", userBean);
			return "/user/myInfo";
		}
		return "redirect:/logout";
	}

	@PostMapping("myInfo")
	@ResponseBody
	public String myInfoUpdate(@ModelAttribute UserBean userBean) {
	    userBean.setAddr(userBean.getAddr() + "," + userBean.getAddr2());
	    int updateResult = userService.update(userBean);
	    return updateResult == 1 ? "1" : "0";
	}

	@GetMapping("changepw")
	public String changePW(@ModelAttribute("userId") String userId, Model model) {
		model.addAttribute("userId", userId);
		return "/user/changepw";
	}

	@PostMapping("pwUpdate")
	@ResponseBody
	public String pwUpdate(UserBean userBean) {
		int updateResult = userService.pwUpdate(userBean);
		return updateResult == 1 ? "1" : "0";
	}
	
	@GetMapping("disconnectKakao")
	@ResponseBody
	public String dconnKkao(@ModelAttribute("userId") String userId) {
		return String.valueOf(userService.dconKka(userId));
	}
	
	@GetMapping("disconnectNaver")
	@ResponseBody
	public String dconnNa(@ModelAttribute("userId") String userId) {
		return String.valueOf(userService.dconNa(userId));
	}

	@GetMapping("delete")
	public String delete(@ModelAttribute("userId") String userId, Model model) {
		model.addAttribute("userId", userId);
		return "/user/delete";
	}

	@PostMapping("delete")
	@ResponseBody
	public String delete2(UserBean userBean, HttpSession session, SessionStatus sessionStatus) {
		if (userService.verify(userBean)) {
			resService.delete(userBean.getUid());
			userService.delete(userBean.getUid());
			sessionStatus.setComplete();
			session.invalidate();
			return "1";
		} else {
			return "0";
		}
	}
	
	@GetMapping("myPage")
	public String temp() {
		return "/module/myPage";
	}
}
