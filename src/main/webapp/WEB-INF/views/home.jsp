<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cpath" value="${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>weatherAPI</title>
<style>
	.clock {
		display: flex;
	}
	#h2{
		background-color: black;
		color: pink;
		margin-left: 5px;
	}
</style>

</head>
<body>

<h1>공공데이터API 활용. 동네예보 2.0</h1>
<hr>

<div class="clock">
	<h2>부산 광역시 수영구 광안1동 동네 예보 - </h2> 
	<h2 id="h2"></h2>
</div>

<table border="1" cellspacing="0" cellpadding="5" id="root"></table>

<script>
	
	const url = '${cpath}/weather'
	const opt = {
		method: 'GET'
	}
	fetch(url, opt).then(resp => resp.json())
	.then(json => {
		const arr = json.response.body.items.item;
		//받아온 데이터에서 필요 항목들만 새로운 배열로 추려낸다.
		const arrSky = Array.from(arr.filter(e => e.category == 'SKY'))
		const arrPcp = Array.from(arr.filter(e => e.category == 'PCP'))
		const arrWsd = Array.from(arr.filter(e => e.category == 'WSD'))
		
		// 6시간치 예보를 출력한다
		for(let i = 0; i < 6; i++){
			const tr = document.createElement('tr')
			const date = arrSky[i].fcstDate
			const td1 = document.createElement('td')
			td1.innerText = date.slice(0,4)+'-'+date.slice(4,6)+'-'+date.slice(6,date.length)
			tr.appendChild(td1)
			
			const time = arrSky[i].fcstTime
			const td2 = document.createElement('td')
			td2.innerText = time.slice(0,2) + '시'
			tr.appendChild(td2)
			
			const sky = document.createElement('td')
			switch(arrSky[i].fcstValue) {
				case '1': 
					sky.innerText = '날씨 : 맑음' 
					break;
				case '3':
					sky.innerText = '날씨 : 구름많음'
					break;
				case '4':
					sky.innerText = '날씨 : 흐림'
					break;
				}
				tr.appendChild(sky)
			const pcp = document.createElement('td')
			pcp.innerText = '강수량 : ' + arrPcp[i].fcstValue.replace('??','')
			tr.appendChild(pcp)
			
			const wsd = document.createElement('td')
			wsd.innerText = '풍속 : ' + arrWsd[i].fcstValue + 'm/s'
			tr.appendChild(wsd)
			document.getElementById('root').appendChild(tr)	
		}
		
		
		
	})
	// 전자시계 만들기
	const h2 = document.getElementById('h2')
	
	function getTime() {
		const date = new Date()
		const minutes = date.getMinutes() < 10 ? '0'+date.getMinutes() : date.getMinutes()
	    const hours = date.getHours() < 10 ? '0'+date.getHours() : date.getHours()
	    const seconds = date.getSeconds() < 10 ? '0'+date.getSeconds() : date.getSeconds()

	    h2.innerText = hours + ':' + minutes + ':' + seconds
	}
	
	function init() {
		setInterval(getTime, 1000)
	}
	
	init()
	

</script>

</body>
