package kr.co.peterpet.prod.controller;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.co.peterpet.prod.ProdBean;
import kr.co.peterpet.prod.ProdService;
import kr.co.peterpet.util.PageBean;

@Controller
@RequestMapping("/admin/prod")
public class ProdAdminController {
	@Autowired
	private ProdService prodService;

	// 검색 조건 목록 설정
	@ModelAttribute("conditionMap")
	public Map<String, String> searchConditionMap() {
		Map<String, String> conditionMap = new HashMap<String, String>();
		conditionMap.put("상품코드", "PCODE");
		conditionMap.put("상품명", "PNAME");
		return conditionMap;
	}

	@RequestMapping("/list/{page}")
	public String adProdList(
			ProdBean prod, PageBean pageBean, 
			@PathVariable int page,
			HttpServletRequest request, Model model) throws ServletException, IOException {
		String condition = request.getParameter("condition");
		String keyword = request.getParameter("keyword");
		System.out.println("page 값 in list : " + page);
		if (condition != null) {
			prod.setSearchCondition(condition);
		}else if(prod.getSearchCondition() == null) {
			prod.setSearchCondition("PNAME");
		}
		
		if (keyword != null) {
			try {
				String decodedKeyword = URLDecoder.decode(keyword, StandardCharsets.UTF_8.name());
				prod.setSearchKeyword(decodedKeyword);
			} catch (UnsupportedEncodingException e) {
                throw new ServletException("Unsupported Encoding", e);
            }
		}else if (prod.getSearchKeyword() == null) {
			prod.setSearchKeyword("");
		}
		
		System.out.println("condition : " + prod.getSearchCondition());
		System.out.println("keyword : " + prod.getSearchKeyword());

		pageBean.setCurrentPage(page);
		System.out.println("currentPage값 in list : " + pageBean.getCurrentPage());

		int listCount = prodService.getListCount(prod);

		int totalPages = listCount / 10 + (listCount % 10 == 0 ? 0 : 1);
		int startPage = ((page - 1) / 5) * 5 + 1;
		int endPage = startPage + 5 - 1;

		if (endPage > totalPages) {
			endPage = totalPages;
		}
		int offset = (page - 1) * 10;
		prod.setOffset(offset);

		pageBean.setTotalPages(totalPages);
		pageBean.setEndPage(endPage);
		pageBean.setListCount(listCount);
		pageBean.setStartPage(startPage);

		List<ProdBean> prodList = (List<ProdBean>) prodService.getAdProdList(prod);
		model.addAttribute("prod", prod);
		model.addAttribute("prodList", prodList);
		model.addAttribute("page", pageBean);

		return "admin/prod/prodlist";
	}

	@RequestMapping(value = "/insertProd", method = RequestMethod.GET)
	public String insertView() {
		System.out.println("상품등록 화면으로 이동");
		return "admin/prod/insertForm";
	}

	@RequestMapping(value = "/insertProd", method = RequestMethod.POST)
	public String insertProd(ProdBean prod, HttpServletRequest request) throws IOException {
		System.out.println("상품등록 진행...");
		String path = request.getServletContext().getRealPath("/resources/upload");
		System.out.println("path : " + path);

		File uploadDir = new File(path);
		if (!uploadDir.exists())
			uploadDir.mkdirs();

		MultipartFile uploadFile1 = prod.getUploadFile1();
		List<MultipartFile> uploadFile2 = prod.getUploadFile2();
		System.out.println("uploadFile2 : " + uploadFile2);

		List<String> fileNames = new ArrayList<>();

		for (MultipartFile file : uploadFile2) {
			String pimg2 = file.getOriginalFilename();
			if (!file.isEmpty()) {
				fileNames.add(pimg2);
			}
		}

		String chgFileNames = fileNames.stream().collect(Collectors.joining(", "));
		System.out.println("pimg2 List : " + fileNames);
		System.out.println("pimg2 하나의 문자열 : " + chgFileNames);

		if (!uploadFile1.isEmpty()) {
			String pimg1 = uploadFile1.getOriginalFilename();
			File file1 = new File(uploadDir, pimg1);
			uploadFile1.transferTo(file1);
			prod.setPimg1(pimg1);
			System.out.println("파일 업로드 성공");
		}

		if (!fileNames.isEmpty()) {
			prod.setPimg2(chgFileNames);
			for (int i = 0; i < uploadFile2.size(); i++) {
				MultipartFile file = uploadFile2.get(i);
				if (!file.isEmpty()) {
					String fileName = fileNames.get(i);
					File targetFile = new File(uploadDir, fileName);
					file.transferTo(targetFile);
				}
			}
			System.out.println("다중 파일 업로드 성공!");
		}

		prodService.insertProd(prod);
		return "redirect:list";
	}

	@RequestMapping(value = "/delete/{page}/{pcode}", method = RequestMethod.GET)
	public String delete(@PathVariable String page, @PathVariable String pcode, Model model) {
		System.out.println("delete url맵핑, pcode :" + pcode);
		int isDelete = prodService.deleteProd(pcode);

		if (isDelete != 0) { // 삭제 성공시
			System.out.println("delete 성공, pcode :" + pcode);
		} else {
			System.out.println("delete 실패, pcode :" + pcode);
		}
		return "redirect:/admin/prod/list/" + page;
	}
	
	@RequestMapping(value = "/delete/{page}/{pcode}/{searchCondition}/{searchKeyword}", method = RequestMethod.GET)
	public String deleteSearch(
			ProdBean prod, 
			@PathVariable String page,
			@PathVariable String pcode, 
			@PathVariable String searchCondition,
			@PathVariable String searchKeyword,
			Model model) {
		System.out.println("delete url맵핑, pcode :" + pcode);
		int isDelete = prodService.deleteProd(pcode);

		if (isDelete != 0) { // 삭제 성공시
			System.out.println("delete 성공, pcode :" + pcode);
		} else {
			System.out.println("delete 실패, pcode :" + pcode);
		}
		
		prod.setSearchCondition(searchCondition);
		prod.setSearchKeyword(searchKeyword);
		model.addAttribute("prod", prod);
		return "redirect:/admin/prod/list/" + page;
	}

	@RequestMapping(value = "/getProdDetail/{page}/{pcode}", method = RequestMethod.GET)
	public String getProdDetail(
			ProdBean prod, @PathVariable String page, 
			@PathVariable String pcode, Model model) {
		System.out.println("pcode in Detail" + prod.getPcode());
		prod = prodService.getProd(prod);

		model.addAttribute("prod", prod);
		model.addAttribute("page", page);
		return "admin/prod/prodDetail";
	}
	
	@RequestMapping(value = "/getProdDetail/{page}/{pcode}/{searchCondition}/{searchKeyword}", method = RequestMethod.GET)
	public String getProdDetailSearch(
			ProdBean prod, @PathVariable String page, 
			@PathVariable String pcode, 
			@PathVariable String searchCondition,
			@PathVariable String searchKeyword,
			Model model) throws ServletException, IOException {
			System.out.println("search 조건 in DetailSearch : " + prod.getSearchCondition() + ", " + prod.getSearchKeyword());;
			prod = prodService.getProd(prod);
			
			if (searchKeyword != null) {
				try {
					String decodedKeyword = URLDecoder.decode(searchKeyword, StandardCharsets.UTF_8.name());
					prod.setSearchKeyword(decodedKeyword);
				} catch (UnsupportedEncodingException e) {
	                throw new ServletException("Unsupported Encoding", e);
	            }
			}else if (prod.getSearchKeyword() == null) {
				prod.setSearchKeyword("");
			}
			
			prod.setSearchCondition(searchCondition);
			model.addAttribute("prod", prod);
			model.addAttribute("page", page);
			return "admin/prod/prodDetail";
	}

	@RequestMapping("/getPcode")
	@ResponseBody
	public Map<String, String> getPcode(@RequestParam String ptype) {

		String pcode = prodService.getPcode(ptype);

		Map<String, String> result = new HashMap<String, String>();
		if (pcode != null && !pcode.isEmpty()) {
			result.put("pcode", pcode);
		}
		return result;
	}

	@RequestMapping("/checkPcode")
	@ResponseBody
	public Map<String, String> checkPcode(@RequestParam String pcode) {

		int exist = prodService.checkPcode(pcode);

		Map<String, String> result = new HashMap<String, String>();
		if (exist > 0) {
			result.put("exist", "1");
		} else {
			result.put("exist", "0");
		}
		return result;
	}

	@RequestMapping(value = "/updateProd/{page}", method = RequestMethod.POST)
	public String updateProd(
			ProdBean prod, @RequestParam String pcode, 
			@PathVariable String page,
			HttpServletRequest request, Model model) throws IOException {
		System.out.println("pimg1 in Update : " + prod.getPimg1());
		System.out.println("pname in Update : " + prod.getPname());
		System.out.println("pprice in Update : " + prod.getPprice());
		System.out.println("pdes in Update : " + prod.getPdes());

		String path = request.getServletContext().getRealPath("/resources/upload");

		File uploadDir = new File(path);
		if (!uploadDir.exists())
			uploadDir.mkdirs();

		MultipartFile uploadFile1 = prod.getUploadFile1();
		List<MultipartFile> uploadFile2 = prod.getUploadFile2();

		List<String> fileNames = new ArrayList<>();

		for (MultipartFile file : uploadFile2) {
			String pimg2 = file.getOriginalFilename();
			if (!file.isEmpty()) {
				fileNames.add(pimg2);
			}
		}

		String chgFileNames = fileNames.stream().collect(Collectors.joining(", "));
		System.out.println("pimg2 하나의 문자열 : " + chgFileNames);

		if (!uploadFile1.isEmpty()) {
			String pimg1 = uploadFile1.getOriginalFilename();
			File file1 = new File(uploadDir, pimg1);

			// 기존 파일 확인
			File[] filesInUpload = uploadDir.listFiles();
			List<String> existingFileNames = new ArrayList<>();
			if (filesInUpload != null) {
				for (File existingFile : filesInUpload) {
					existingFileNames.add(existingFile.getName());
				}
			}

			if (existingFileNames.contains(pimg1)) {
				File existingFile = new File(uploadDir, pimg1);
				if (existingFile.delete()) {
					System.out.println("기존 파일 삭제 성공");
				} else {
					System.out.println("기존 파일 삭제 실패");
				}
			}

			uploadFile1.transferTo(file1);
			prod.setPimg1(pimg1);
			System.out.println("파일 업로드 성공");
		}

		if (!fileNames.isEmpty()) {
			File[] filesInUpload = uploadDir.listFiles();
			List<String> existingFileNames = new ArrayList<>();
			if (filesInUpload != null) {
				for (File existingFile : filesInUpload) {
					existingFileNames.add(existingFile.getName());
				}
			}

			for (int i = 0; i < uploadFile2.size(); i++) {
				MultipartFile file = uploadFile2.get(i);

				if (!file.isEmpty()) {
					String fileName = fileNames.get(i);
					File targetFile = new File(uploadDir, fileName);

					if (existingFileNames.contains(fileName)) {
						File existingFile = new File(uploadDir, fileName);
						if (existingFile.delete()) {
							System.out.println("Pimg2 기존 파일 삭제 성공");
						} else {
							System.out.println("Pimg2 기존 파일 삭제 실패");
						}
					}

					file.transferTo(targetFile);
					System.out.println("파일 " + fileName + " 업로드 성공!");
				}
			}

			prod.setPimg2(chgFileNames);
		}
		String result = null;
		prodService.updateProd(prod);
		System.out.println("search 조건 in update : " + prod.getSearchCondition() + ", " + prod.getSearchKeyword());
		if(prod.getSearchKeyword() != null && !prod.getSearchKeyword().trim().equals("")) {
			result = "redirect:/admin/prod/getProdDetail/" + page + "/" + pcode + "/" + prod.getSearchCondition() + "/" + prod.getSearchKeyword(); 
		}else {
			result = "redirect:/admin/prod/getProdDetail/" + page + "/" + pcode; 
		}
		System.out.println("result 값 : " + result);
		return result; 
	}
}
