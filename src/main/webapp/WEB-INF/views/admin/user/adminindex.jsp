<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>통계 차트</title>
    <style>
 
       


        /* 도넛 차트와 막대 차트 배치 */
        .doughnut-chart-row {
            display: flex;
            justify-content: space-between;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .doughnut-chart {
            flex: 1;
            height: 40vh;
        }

        .bar-chart-row {
            display: flex;
            justify-content: space-between;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .bar-chart {
            flex: 1;
            height: 45vh;
        }

        canvas {
            width: 100% !important;
            height: 100% !important;
        }

       

        /* 반응형 디자인 */
        @media (max-width: 768px) {
            .doughnut-chart-row, .bar-chart-row {
                flex-direction: column;
            }
            .doughnut-chart, .bar-chart {
                height: 30vh;
            }
        }
    </style>
</head>
<body>
    <nav>
        <%@ include file="/WEB-INF/views/module/anav.jsp"%>
    </nav>

    
        <!-- 도넛 차트 두 개를 수평으로 배치 -->
        <div class="doughnut-chart-row">
            <div class="doughnut-chart">
                <canvas id="genderDistributionChart"></canvas>
            </div>
            <div class="doughnut-chart">
                <canvas id="chart2"></canvas>
            </div>
        </div>

        <!-- 막대 그래프 두 개를 수평으로 배치 -->
        <div class="bar-chart-row">
            <div class="bar-chart">
                <canvas id="ageDistributionChart"></canvas>
            </div>
            <div class="bar-chart">
                <canvas id="chart1"></canvas>
            </div>
        </div>

 

    <footer>
        <!-- Include your footer here -->
        <jsp:include page="/WEB-INF/views/module/footer.jsp" />
    </footer>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.0.0/dist/chartjs-plugin-datalabels.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.7/dist/umd/popper.min.js"></script>
    <script>
        // 서버에서 전달된 JSON 데이터를 JavaScript에서 사용할 수 있는 형식으로 변환
        var userListString = '${userListString}';
        var userList = JSON.parse(userListString);

        var ageLabels = userList.map(item => item.age_range);
        var ageData = userList.map(item => item.user_count);

        var ctxAge = document.getElementById('ageDistributionChart').getContext('2d');
        var ageDistributionChart = new Chart(ctxAge, {
            type: 'bar',
            data: {
                labels: ageLabels,
                datasets: [{
                    label: '회원 가입자 수 (${UserCount})',
                    data: ageData,
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });

        var genderDataString = '${genderDataString}';
        var genderData = JSON.parse(genderDataString);

        var genderLabels = genderData.map(item => item.gender_label);
        var genderDataValues = genderData.map(item => item.count);

        var ctxGender = document.getElementById('genderDistributionChart').getContext('2d');
        var genderDistributionChart = new Chart(ctxGender, {
            type: 'doughnut',
            data: {
                labels: genderLabels,
                datasets: [{
                    label: '회원 성별 분포',
                    data: genderDataValues,
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(54, 162, 235, 0.2)',
                        'rgba(255, 206, 86, 0.2)'
                    ],
                    borderColor: [
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                    },
                    tooltip: {
                        callbacks: {
                            label: function(tooltipItem) {
                                return tooltipItem.label + ': ' + tooltipItem.raw + '명 (' + Math.round(tooltipItem.raw / genderData.reduce((acc, item) => acc + item.count, 0) * 100) + '%)';
                            }
                        }
                    },
                    datalabels: {
                        color: '#000',
                        display: true,
                        formatter: function(value, context) {
                            var total = context.dataset.data.reduce((acc, val) => acc + val, 0);
                            var percentage = ((value / total) * 100).toFixed(2);
                            return value + '명\n' + percentage + '%';
                        },
                        font: {
                            size: 14,
                            weight: 'bold'
                        },
                        anchor: 'center',
                        align: 'center'
                    },
                    title: {
                        display: true,
                        text: '회원 성별 분포 (${UserCount}명)',
                        font: {
                            size: 18,
                            weight: 'bold'
                        },
                        padding: {
                            top: 10,
                            bottom: 30
                        }
                    }
                }
            }
        });

        const ctx1 = document.getElementById('chart1').getContext('2d');
        var chart1 = new Chart(ctx1, {
            type: 'bar',
            data: {
                labels: ['유치원', '호텔', '미용'],
                datasets: [{
                    label: '유치원,호텔,미용 비율',
                    data: ['${chartBean.count1}', '${chartBean.count2}', '${chartBean.count3}'],
                    backgroundColor: 'rgba(255, 99, 132, 0.2)',
                    borderColor: 'rgba(255, 99, 132, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });

        const ctx2 = document.getElementById('chart2').getContext('2d');
        var chart2 = new Chart(ctx2, {
            type: 'doughnut',
            data: {
                labels: ['패키지', '간식', '미용', '사료', '영양제', '장난감'],
                datasets: [{
                    label: '# 상품 타입',
                    data: ['${chartBean2.ptype1}', '${chartBean2.ptype2}', '${chartBean2.ptype3}', '${chartBean2.ptype4}', '${chartBean2.ptype5}', '${chartBean2.ptype6}'],
                    backgroundColor: [
                        'rgba(100, 149, 237, 0.6)', // 부드러운 파랑
                        'rgba(144, 238, 144, 0.6)', // 부드러운 초록
                        'rgba(255, 255, 102, 0.6)', // 부드러운 노랑
                        'rgba(255, 182, 193, 0.6)', // 부드러운 핑크
                        'rgba(255, 165, 0, 0.6)', // 부드러운 오렌지
                        'rgba(186, 85, 211, 0.6)'  // 부드러운 보라
                    ],
                    borderColor: [
                        'rgba(100, 149, 237, 1)', // 부드러운 파랑
                        'rgba(144, 238, 144, 1)', // 부드러운 초록
                        'rgba(255, 255, 102, 1)', // 부드러운 노랑
                        'rgba(255, 182, 193, 1)', // 부드러운 핑크
                        'rgba(255, 165, 0, 1)', // 부드러운 오렌지
                        'rgba(186, 85, 211, 1)'  // 부드러운 보라
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                    },
                    title: {
                        display: true,
                        text: '상품 타입 분포',
                        font: {
                        	size: 18,
                            weight: 'bold'
                        },
                        padding: {
                            top: 10,
                            bottom: 10
                        }
                    },
                    datalabels: {
                        color: '#000',
                        display: true,
                        formatter: function(value, context) {
                            var total = context.dataset.data.reduce((acc, val) => acc + val, 0);
                            var percentage = ((value / total) * 100).toFixed(2);
                            return value + '개\n' + percentage + '%';
                        },
                        font: {
                            size: 14,
                            weight: 'bold'
                        },
                        anchor: 'center',
                        align: 'center'
                    }
                }
            }
        });

    </script>
</body>
</html>
