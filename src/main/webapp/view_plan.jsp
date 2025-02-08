<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>여행 일정</title>
  <link rel="stylesheet" href="styles.css">
  <style>
      /* General Reset */
      * {
          margin: 0;
          padding: 0;
          box-sizing: border-box;
          font-family: 'Arial', sans-serif;
      }

      body {
          display: flex;
          height: 100vh;
          background-color: #D9F2FF;
      }

      /* Container */
      .container {
          display: flex;
          width: 100%;
      }

      /* Sidebar */
      .sidebar {
          width: 220px;
          background: #fff;
          display: flex;
          flex-direction: column;
          padding: 20px;
          border-right: 1px solid #ddd;
      }

      .full-schedule,
      .save-btn {
          background: #007BFF;
          color: white;
          border: none;
          padding: 10px;
          font-size: 16px;
          cursor: pointer;
          margin-bottom: 20px;
          border-radius: 5px;
      }

      .days-nav {
          flex-grow: 1;
      }

      .day-btn {
          box-shadow: 0 2px 8px 0 rgba(31, 38, 135, .08);
          width: 100%;
          background: none;
          border: none;
          padding: 10px;
          font-size: 16px;
          cursor: pointer;
          border-radius: 5px;
          margin-bottom: 5px;
      }

      .day-btn.active {
          background: #007BFF;
          color: white;
      }

      /* Main Content */
      .main-content {
          flex-grow: 2;
          padding: 20px 40px;
          display: flex;
          flex-direction: column;
      }

      .trip-header {
          font-size: 24px;
          font-weight: bold;
          margin-bottom: 20px;
      }

      .date {
          font-size: 23px;
      }

      /* Itinerary Section */
      .itinerary {
          display: flex;
          flex-direction: column;
          gap: 15px;
      }

      .day-schedule {
          background: white;
          padding: 15px;
          border-radius: 8px;
          box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
          display: flex;
          flex-direction: column;
          gap: 10px;
      }

      .schedule-item {
          display: flex;
          align-items: center;
          gap: 15px;
          padding: 15px 0;
      }

      .step-number {
          width: 18px;
          height: 18px;
          background-color: rgb(229, 75, 75);
          color: white;
          font-size: 0.75rem;
          font-weight: bold;
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          flex-shrink: 0;
      }

      .time-category {
          display: flex;
          flex-direction: column;
          align-items: flex-start;
          gap: 3px;
      }

      .time {
          font-size: 15px;
          font-weight: bold;
          color: rgb(170, 177, 184);
      }

      .place-type {
          font-size: 12px;
          color: #007BFF;
          font-weight: bold;
      }

      .place-name {
          font-size: 16px;
          font-weight: bold;
          color: #333;
      }

      .travel-time {
          display: flex;
          align-items: center;
          font-size: 14px;
          color: #777;
          padding-left: 40px;
          gap: 5px;
          margin-top: -5px;
      }

      .place-image {
          width: 60px;
          height: 60px;
          object-fit: cover;
          border-radius: 8px;
      }

      /* Right Panel (Map Placeholder) */
      .right-panel {
          width: 50%;
          flex-grow: 1;
          background: #B3E0FF;
          display: flex;
          align-items: center;
          justify-content: center;
          border-left: 1px solid #ddd;
      }

      .hidden {
          display: none;
      }
  </style>
</head>
<body>
<div class="container">
  <!-- Left Sidebar -->
  <aside class="sidebar">
    <button class="full-schedule" id="fullScheduleBtn">전체일정</button>
    <nav class="days-nav" id="daysNav">
      <!-- Create a day–button for each date -->
      <c:forEach var="date" items="${plan.dates}" varStatus="status">
        <button class="day-btn" data-day-index="${status.index}">${status.index + 1}일차</button>
      </c:forEach>
    </nav>
    <!-- Show the copy (내 일정에 담기) button only if the logged-in user is NOT the owner -->
    <c:if test="${sessionScope.user_idx != plan.user_idx}">
      <button class="save-btn" id="copyPlanBtn">내 일정에 담기</button>
    </c:if>
  </aside>

  <!-- Main Content -->
  <main class="main-content">
    <header class="trip-header">
      <h1>${plan.title} <span class="date" id="duration">${plan.start_date} - ${plan.end_date}</span></h1>
    </header>

    <!-- Itinerary Section -->
    <section class="itinerary" id="itinerarySection">
      <!-- By default, show full schedule (all days) -->
      <c:forEach var="date" items="${plan.dates}" varStatus="status">
        <div class="day-schedule" data-day-index="${status.index}">
          <h2>${status.index + 1}일차 <span class="date">${date.date}</span></h2>
          <c:forEach var="place" items="${date.places}" varStatus="placeStatus">
            <div class="schedule-item">
              <span class="step-number">${placeStatus.index + 1}</span>
              <div class="time-category">
                <span class="time">${place.time}</span>
                <span class="place-type">
                  <c:choose>
                    <c:when test="${place.content_type_id == 1}">🏨 숙소</c:when>
                    <c:otherwise>📍 장소</c:otherwise>
                  </c:choose>
                </span>
                <span class="place-name">${place.title}</span>
              </div>
              <c:if test="${not empty place.thumbnail}">
                <img src="${place.thumbnail}" class="place-image" alt="${place.title}" />
              </c:if>
            </div>
            <div class="travel-time">
              🚗 <span>이동시간</span>
            </div>
          </c:forEach>
        </div>
      </c:forEach>
    </section>
  </main>

  <!-- Right Panel (Map Placeholder) -->
  <aside class="right-panel hidden" id="rightPanel">
    <!-- Map will be integrated later -->
    <span>Map Placeholder</span>
  </aside>
</div>

<!-- Hidden element to pass plan metadata for JavaScript -->
<div id="planData"
     data-plan-id="${plan.idx}"
     data-owner="${plan.user_idx}"
     data-user="${sessionScope.user_idx}">
</div>

<script>
  // ----- Day Navigation Handling -----
  const dayButtons = document.querySelectorAll('.day-btn');
  const daySchedules = document.querySelectorAll('.day-schedule');
  const rightPanel = document.getElementById('rightPanel');
  const fullScheduleBtn = document.getElementById('fullScheduleBtn');

  dayButtons.forEach(btn => {
    btn.addEventListener('click', function() {
      // Remove active class from all day buttons.
      dayButtons.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      const dayIndex = btn.getAttribute('data-day-index');
      // Hide all schedules...
      daySchedules.forEach(schedule => {
        schedule.style.display = 'none';
      });
      // ...and show the selected day schedule.
      const selected = document.querySelector('.day-schedule[data-day-index="'+dayIndex+'"]');
      if(selected) {
        selected.style.display = 'block';
      }
      // Show the right panel when a single day is selected.
      rightPanel.classList.remove('hidden');
    });
  });

  // "전체일정" button shows all days and hides the right panel.
  fullScheduleBtn.addEventListener('click', function() {
    dayButtons.forEach(b => b.classList.remove('active'));
    daySchedules.forEach(schedule => {
      schedule.style.display = 'block';
    });
    rightPanel.classList.add('hidden');
  });

  // ----- Copy (내 일정에 담기) Handling -----
  const copyPlanBtn = document.getElementById('copyPlanBtn');
  if(copyPlanBtn){
    copyPlanBtn.addEventListener('click', function() {
      const planDataElem = document.getElementById('planData');
      const sessionUser = planDataElem.getAttribute('data-user');
      const ownerUser = planDataElem.getAttribute('data-owner');
      if(!sessionUser) {
        window.location.href = "login.jsp";
        return;
      }
      if(sessionUser === ownerUser) {
        alert("자신의 계획은 복사할 수 없습니다.");
        return;
      }
      // For simplicity, use prompt() to get new start and end dates.
      const newStartDate = prompt("새로운 시작일을 입력하세요 (YYYY-MM-DD):");
      const newEndDate = prompt("새로운 종료일을 입력하세요 (YYYY-MM-DD):");
      const planId = planDataElem.getAttribute('data-plan-id');
      const data = {
        planId: parseInt(planId),
        start_date: newStartDate,
        end_date: newEndDate
      };
      fetch("Controller?type=copyPlan", {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify(data)
      })
          .then(response => response.json())
          .then(result => {
            if(result.success){
              window.location.href = "Controller?type=viewPlan&planId=" + result.newPlanId;
            } else {
              alert(result.error);
            }
          })
          .catch(error => console.error("Error:", error));
    });
  }
</script>
</body>
</html>
