package com.itbank.service;

import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Scanner;

import org.springframework.stereotype.Service;

@Service
public class WeatherService {
	
	private final String serviceKey = "";// 계정으로 인증받은 서비스키 입력
	private final String url = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst";
	
	public String getWeatherJSON() throws Exception {
		String base_date = new SimpleDateFormat("yyyyMMdd").format(new Date());
		int time = Integer.parseInt(new SimpleDateFormat("HH").format(new Date()));
		String base_time = String.format("%02d00", time / 3 * 3 - 1);
		
		String query = "?";
		HashMap<String, String> param = new HashMap<String, String>();
		param.put("serviceKey",	serviceKey);
		param.put("numOfRows", "66");
		param.put("pageNo", "1");
		param.put("dataType", "JSON");
		param.put("base_date", base_date);
		param.put("base_time", base_time);
		param.put("nx", "99");
		param.put("ny", "75");
		
		for(String key : param.keySet()) {
			String value = param.get(key);
			query += key + "=" + value + "&";
		}
		
		URL requestURL = new URL(url + query);
		HttpURLConnection conn = (HttpURLConnection) requestURL.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Content-Type", "application/json;charset=utf-8");
		
		Scanner sc = null;
		String json = "";
		if(conn.getResponseCode() == 200) {
			sc = new Scanner(conn.getInputStream());
			while(sc.hasNextLine()) {
				json += sc.nextLine();
			}
			sc.close();
			conn.disconnect();
			return json;
		}	
		return null;
	}
	
}
