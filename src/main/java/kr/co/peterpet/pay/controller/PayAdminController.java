package kr.co.peterpet.pay.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import kr.co.peterpet.pay.PayBean;
import kr.co.peterpet.pay.PayService;
import kr.co.peterpet.util.PageBean;

@Controller
@RequestMapping("/admin/pay")
public class PayAdminController {
	@Autowired
	private PayService payService;
	
	@ModelAttribute("payconditionMap")
	public Map<String, String> searchConditionMap() {
		Map<String, String> payconditionMap = new HashMap<String, String>();
		payconditionMap.put("주문번호", "PAYMENTID");
		payconditionMap.put("주문명", "ORDERNAME");
		return payconditionMap;
	}
	
	@RequestMapping("/list/{page}")
	public String getPayList(PayBean pay, PageBean pageBean,
			@PathVariable int page, HttpServletRequest request, Model model) {
		
		String condition = request.getParameter("condition");
		String keyword = request.getParameter("keyword");
		System.out.println("page 값 in list : " + page);
		if (condition != null) {
			pay.setSearchCondition(condition);
		}else if(pay.getSearchCondition() == null) {
			pay.setSearchCondition("PAYMENTID");
		}
		
		if (keyword != null) {
			pay.setSearchKeyword(keyword);
		}else if (pay.getSearchKeyword() == null) {
			pay.setSearchKeyword("");
		}
		
		pageBean.setCurrentPage(page);
		System.out.println("currentPage값 in list : " + pageBean.getCurrentPage());

		int listCount = payService.getListCount();

		int totalPages = listCount / 10 + (listCount % 10 == 0 ? 0 : 1);
		int startPage = ((page - 1) / 5) * 5 + 1;
		int endPage = startPage + 5 - 1;

		if (endPage > totalPages) {
			endPage = totalPages;
		}
		int offset = (page - 1) * 10;
		pay.setOffset(offset);

		pageBean.setTotalPages(totalPages);
		pageBean.setEndPage(endPage);
		pageBean.setListCount(listCount);
		pageBean.setStartPage(startPage);
		
		List<PayBean> payList = payService.getAdPayList(pay);
		model.addAttribute("pay", pay);
		model.addAttribute("payList", payList);
		model.addAttribute("page", pageBean);
		
		return "admin/pay/payList";
	}
	
	@RequestMapping(value = "/getPayDetail/{page}/{paymentId}", method = RequestMethod.GET)
	public String getPayDetail(
			PayBean pay, @PathVariable String page, 
			@PathVariable String paymentId, Model model) {
		List<PayBean> paidList = payService.getPayDetail(paymentId);

		model.addAttribute("paidList", paidList);
		model.addAttribute("page", page);
		return "pay/payDetail";
	}
}
