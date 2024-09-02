package kr.co.peterpet.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class Interceptor extends HandlerInterceptorAdapter {
    private static final Logger logger = LoggerFactory.getLogger(Interceptor.class);

    static final String[] EXCLUDE_URL_LIST = {
    		"/prod/info",
    		"/prod/list",
    		"/prod/detail/",
    		"/user/map",
    		"/pay/bestProdList"
    };

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        String reqUrl = request.getRequestURI(); // 요청 URL
        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");
        if((userId == null)&&(!reqUrl.equals("/res/checkRes")) && (!reqUrl.equals("/pay/doOrder"))&& (!reqUrl.equals("/pay/bestProdList"))) {
        	session.setAttribute("url", reqUrl);
        	System.out.println("\n\n\n\n\n\n\n\n\n\n\n인터셉터 url 저장 : "+session.getAttribute("url"));
        }
        // 로그인 체크 제외 리스트 처리
        for (String target : EXCLUDE_URL_LIST) {
            if (reqUrl.startsWith(target)) {
                return true; // 제외된 URL은 인터셉터를 통과
            }
        }

        if (userId == null || userId.trim().isEmpty()) {
            if (reqUrl.equals("/admin")) {
            	response.sendRedirect(request.getContextPath() + "/admin/login");
            } else {
	        	logger.info(">> 로그인 안해서 로그인 요청 ");
	            session.removeAttribute("userId");
	            response.sendRedirect(request.getContextPath() + "/login");
	        }
            return false;
        } else if (!userId.equals("admin") && reqUrl.startsWith("/admin")) {
            logger.info(">> 비관리자가 admin URL에 접근 시도, 루트로 리다이렉트");
            response.sendRedirect(request.getContextPath() + "/");
            return false;
        }
        session.removeAttribute("url");
        return true; // 모든 체크를 통과하면 요청 처리 계속 진행
    }
}
