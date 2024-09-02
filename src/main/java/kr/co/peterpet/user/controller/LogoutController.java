package kr.co.peterpet.user.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LogoutController {
	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/";
	}
	@GetMapping("/adminlogout")
	public String adminlogout(HttpSession session) {
		session.invalidate();
		return "redirect:/admin/login";
	}
}

