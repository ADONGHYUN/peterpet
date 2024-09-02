package kr.co.peterpet.prod.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.peterpet.prod.ProdBean;
import kr.co.peterpet.prod.ProdService;

@Controller
@RequestMapping("/prod")
public class ProdClientController {
	@Autowired
	private ProdService prodService;
	
	// 페이지 요청 처리
	@RequestMapping("/list")
	public String getProdList(ProdBean prod, Model model) {
        model.addAttribute("prodList", prodService.getProdList(prod));
        return "prod/list";
	}
	
	// AJAX 요청 처리
	@PostMapping("/list")
	@ResponseBody
	public List<ProdBean> getListAjax(ProdBean prod) {

		return prodService.getListAjax(prod);
	}
	
//	@RequestMapping("/list/{page}")
//	public String getListPaging(@PathVariable int page, ProdBean prod, PageInfo pageInfo, Model model) {
//		int page=1;
//	   	int limit=10;
//	   	int maxPage=0;
//	   	int startPage = 0;
//	   	int endPage = 0;
//		if(request.getParameter("page")!=null){
//			page=Integer.parseInt(request.getParameter("page"));
//		}
//        model.addAttribute("prodList", prodService.getProdList(prod));
//        return "prod/list"; // View 이름 리턴
//	}

	@RequestMapping("/detail/pcode/{pcode}")
	public String getProd(@PathVariable String pcode, Model model) {
		ProdBean prod = new ProdBean();
		prod.setPcode(pcode);
		model.addAttribute("prod", prodService.getProd(prod)); // Model 정보 저장
		return "prod/detail";
	}
	
	@RequestMapping("/info")
	public String goinfo() {
		return "prod/info";
	}
	
	@GetMapping(value = "/info/{num}")
	public String content(@PathVariable String num) {
		return "prod/content";
	}
}
