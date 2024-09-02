<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>상품 차트</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #f4f4f9;
        }
        .chart-container {
            width: 50%;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            background-color: white;
            padding: 20px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
        }
        #chart1 {
            width: 80%;  /* chart1의 크기 조정 */
            margin-bottom: 20px;
        }
        #chart2 {
            width: 50%;  /* chart2의 크기 조정 */
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
      window.onload = function() {
        const ctx1 = document.getElementById('chart1').getContext('2d');
        const ctx2 = document.getElementById('chart2').getContext('2d');
        
        // 막대 차트 생성
        var chart1 = new Chart(ctx1, {
          type: 'bar',
          data: {
            labels: ['유치원', '호텔', '미용'],
            datasets: [{
              label: '호텔, 미용 비율',
              data: ['${chartBean.count1}', '${chartBean.count2}', '${chartBean.count3}'],
              backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56'],
              borderWidth: 1
            }]
          },
          options: {
            scales: {
              y: {
                beginAtZero: true
              }
            },
            barPercentage: 0.5,  // 바 너비 조정
            categoryPercentage: 0.5  // 카테고리 너비 조정
          }
        });
        
        // 도넛 차트 생성
        var chart2 = new Chart(ctx2, {
          type: 'doughnut',
          data: {
            labels: ['패키지', '간식', '미용', '사료', '영양제', '장난감'],
            datasets: [{
              label: '# 상품 타입',
              data: ['${chartBean2.ptype1}', '${chartBean2.ptype2}', '${chartBean2.ptype3}', '${chartBean2.ptype4}', '${chartBean2.ptype5}', '${chartBean2.ptype6}'],
              backgroundColor: [
                '#FF6384',
                '#36A2EB',
                '#FFCE56',
                '#4BC0C0',
                '#9966FF',
                '#FF9F40'
              ],
              borderWidth: 1
            }]
          },
          options: {
            responsive: true,
            aspectRatio: 1.5,  // 차트의 가로 세로 비율 조정 (이 값을 변경하여 차트의 크기를 조정할 수 있습니다)
            plugins: {
              legend: {
                position: 'top',
              }
            }
          }
        });
      }
    </script>
</head>
<body>
    <div class="chart-container">
    <h1>상품 통계</h1>
    <h3>유치원에 대한 호텔, 미용의 비율(%)</h3>
        <canvas id="chart1"></canvas>
        <h3>상품 종류별 판매량</h3>
        <canvas id="chart2"></canvas>      
    </div>
</body>
</html>
