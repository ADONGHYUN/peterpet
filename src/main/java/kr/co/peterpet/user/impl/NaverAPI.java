package kr.co.peterpet.user.impl;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import io.netty.handler.timeout.TimeoutException;
import kr.co.peterpet.user.UserBean;

public class NaverAPI {
	private final WebClient webClient;
    private final String client_id;
    private final String loginURI;
    private final String clientSecret;
	
    @Autowired
    public NaverAPI(WebClient.Builder webClientBuilder, String client_id, String loginURI, String clientSecret) {
    	this.webClient = webClientBuilder.build();
    	this.client_id = client_id;
        this.loginURI = loginURI;
        this.clientSecret = clientSecret;
    }
    
    public String getClient_id() {
        return client_id;
    }
    public String getLoginURI() {
        return loginURI;
    }
    
    private void handleException(Exception e) {
        if (e instanceof WebClientResponseException) {
            WebClientResponseException webClientException = (WebClientResponseException) e;
            System.err.println("상태코드에러: " + webClientException.getStatusCode().value() + " - " + webClientException.getStatusText());
            System.err.println("에러 메시지: " + webClientException.getMessage());
        } else if (e instanceof TimeoutException) {
            System.err.println("시간초과로 데이터를 가져오지 못했습니다. " + e.getMessage());
        } else if (e instanceof IOException) {
            System.err.println("JSON 파싱 오류. " + e.getMessage());
        } else {
            System.err.println("로그를 확인해야 알 수 있는 에러. " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    public String getAccessToken(String code, UserBean userBean) {
    	try {
	    	String Token = webClient.get()
				        .uri(uriBuilder -> uriBuilder
				        .scheme("https")
				        .host("nid.naver.com")
				        .path("/oauth2.0/token")
				        .queryParam("grant_type", "authorization_code")
				        .queryParam("client_id", client_id)
				        .queryParam("client_secret", clientSecret)
				        .queryParam("code", code)
				        .build())
				        .retrieve()
				        .bodyToMono(String.class)
				        .block();
	    	
	        if (Token != null && !Token.isEmpty()) {
	        		ObjectMapper objectMapper = new ObjectMapper();
	        		JsonNode node = objectMapper.readTree(Token);
	        		userBean.setNRToken(node.path("refresh_token").asText());
	        		return node.path("access_token").asText();
	        	}
    	} catch (Exception e) {
        	handleException(e);
        } 
        return null;
    }
    
    public void getProfile(UserBean userBean, String accessToken) {
    	try {
	    	String profile = webClient.get()
				        .uri(uriBuilder -> uriBuilder
				        .scheme("https")
				        .host("openapi.naver.com")
				        .path("/v1/nid/me")
				        .build())
				        .header("Authorization", "Bearer " + accessToken)
				        .retrieve()
				        .bodyToMono(String.class)
				        .block();
	    	
	        if (profile != null && !profile.isEmpty()) {
	        		ObjectMapper objectMapper = new ObjectMapper();
	        		JsonNode node = objectMapper.readTree(profile).path("response");

	                userBean.setUname(node.path("name").asText());
	                userBean.setUtel(node.path("mobile").asText().replace("-", ""));
	                userBean.setUemail(node.path("email").asText());
	                userBean.setUbirth(node.path("birthyear").asText()+node.path("birthday").asText().replace("-",""));
	                userBean.setUgender("M".equals(node.path("gender").asText()) ? "남" :
                        "F".equals(node.path("gender").asText()) ? "여" :
                        "U".equals(node.path("gender").asText()) ? "비공개" : "");
	                userBean.setNapi(node.path("id").asText());
	                getAddr(userBean, accessToken);
	        	}
    	} catch (Exception e) {
        	handleException(e);
        } 
    }
    
    public void getAddr(UserBean userBean, String accessToken) {
        try {
            // WebClient를 사용하여 API 요청
            String response = webClient.get()
                    .uri("https://openapi.naver.com/v1/nid/payaddress")
                    .header("Authorization", "Bearer " + accessToken)
                    .retrieve()
                    .bodyToMono(String.class)
                    .block();

            if (response != null && !response.isEmpty()) {
                ObjectMapper objectMapper = new ObjectMapper();
                JsonNode node = objectMapper.readTree(response).path("data");
                userBean.setZcode(node.path("zipCode").asText());
                userBean.setAddr(node.path("baseAddress").asText().replace(",","") + "," + node.path("detailAddress").asText());
            }
        } catch (Exception e) {
        	handleException(e);
        } 
    }
    
    private String getAToken(String RefreshToken) {
    	try {
	        String response = webClient.post()
	                .uri("https://nid.naver.com/oauth2.0/token")
	                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
	                .bodyValue("grant_type=refresh_token&" + 
		                		"client_id=" + client_id + "&" +
		                		"client_secret=" + clientSecret + "&" +
		                		"refresh_token=" + RefreshToken)
	                .retrieve()
	                .bodyToMono(String.class)
	                .block();
	
	        if (response != null && !response.isEmpty()) {
	            ObjectMapper objectMapper = new ObjectMapper();
	            JsonNode node = objectMapper.readTree(response);
	            System.out.println("\n\n\n\n\n\n\n "+node.path("access_token").asText());
	            return node.path("access_token").asText();   
	        }
	    } catch (Exception e) {
	    	handleException(e);
	    }
    	return null;
    }
    
    public boolean dcconNa(String RefreshToken) {
        try {
        	URI uri = new URI("https://nid.naver.com/oauth2.0/token?"
                    + "grant_type=delete"
                    + "&client_id=" + URLEncoder.encode(client_id, StandardCharsets.UTF_8.toString())
                    + "&client_secret=" + URLEncoder.encode(clientSecret, StandardCharsets.UTF_8.toString())
                    + "&access_token=" + URLEncoder.encode(getAToken(RefreshToken), StandardCharsets.UTF_8.toString()));   
        	String response = webClient.get()
        		    .uri(uri)
            	    .retrieve()
            	    .bodyToMono(String.class)
            	    .block();

            if (response != null && !response.isEmpty()) {
                ObjectMapper objectMapper = new ObjectMapper();
                JsonNode node = objectMapper.readTree(response);
                System.out.println("\n\n\n\n\n\n\n "+node.path("result").asText());
                return "success".equals(node.path("result").asText());
            }
        } catch (Exception e) {
        	handleException(e);
        }
        return false;
    }
}
