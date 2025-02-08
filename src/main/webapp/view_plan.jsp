<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>여행 일정 - ${plan.title}</title>
  <link rel="stylesheet" href="styles.css">
  <style>
      /* Use your existing CSS here – for brevity the same styles as before are used. */
      * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Arial', sans-serif; }
      body { display: flex; height: 100vh; background-color: #D9F2FF; }
      .container { display: flex; width: 100%; }
      .sidebar {
          width: 220px; background: #fff; display: flex; flex-direction: column; padding: 20px;
          border-right: 1px solid #ddd;
      }
      .full-schedule, .save-btn { background: #007BFF; color: white; border: none; padding: 10px;
          font-size: 16px; cursor: pointer; margin-bottom: 20px; border-radius: 5px;
      }
      .days-nav { flex-grow: 1; }
      .day-btn { width: 100%; background: none; border: none; padding: 10px; font-size: 16px;
          cursor: pointer; border-radius: 5px; margin-bottom: 5px;
      }
      .day-btn.active { background: #007BFF; color: white; }
      .main-content { flex-grow: 2; padding: 20px 40px; display: flex; flex-direction: column; }
      .trip-header { font-size: 24px; font-weight: bold; margin-bottom: 20px; }
      .date { font-size: 23px; }
      .itinerary { display: flex; flex-direction: column; gap: 15px; }
      .day-schedule {
          background: white; padding: 15px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);
          display: block; /* will be toggled by JS */
      }
      .schedule-item { display: flex; align-items: center; gap: 15px; margin-bottom: 10px; }
      .step-number {
          width: 18px; height: 18px; background-color: rgb(229,75,75); color: #fff;
          font-size: .75rem; font-weight: bold; border-radius: 50%; display: flex;
          align-items: center; justify-content: center;
      }
      .time-category { display: flex; flex-direction: column; align-items: flex-start; }
      .time { font-size: 15px; font-weight: bold; color: rgb(170,177,184); }
      .place-type { font-size: 12px; color: #007BFF; font-weight: bold; }
      .place-name { font-size: 16px; font-weight: bold; color: #333; }
      .place-image {
          width: 60px; height: 60px; object-fit: cover; border-radius: 8px;
      }
      .right-panel {
          width: 50%; flex-grow: 1; background: #B3E0FF; display: flex;
          align-items: center; justify-content: center; border-left: 1px solid #ddd;
      }
  </style>
</head>
<body>
<div class="container">
  <!-- Left Sidebar -->
  <aside class="sidebar">
    <button class="full-schedule" id="fullScheduleBtn">전체일정</button>
    <nav class="days-nav">
      <c:forEach var="date" items="${plan.dateList}" varStatus="status">
        <button class="day-btn ${status.first ? 'active' : ''}" data-index="${status.index}">
            ${status.index + 1}일차
        </button>
      </c:forEach>
    </nav>
    <!-- Show the copy button only if the logged‐in user is NOT the owner -->
    <c:if test="${sessionScope.user_idx ne plan.user_idx}">
      <button class="save-btn" id="copyPlanBtn">내 일정에 담기</button>
    </c:if>
  </aside>

  <!-- Main Content -->
  <main class="main-content" id="mainContent">
    <header class="trip-header">
      <h1>${plan.title} <span class="date" id="duration">${plan.start_date} - ${plan.end_date}</span></h1>
    </header>
    <!-- Itinerary Section -->
    <section class="itinerary" id="itinerarySection">
      <c:forEach var="date" items="${plan.dateList}" varStatus="status">
        <div class="day-schedule" data-day-index="${status.index}">
          <h2>${status.index + 1}일차 <span class="date">${date.date}</span></h2>
          <c:forEach var="place" items="${date.placeList}" varStatus="pStatus">
            <div class="schedule-item">
              <span class="step-number">${pStatus.index + 1}</span>
              <div class="time-category">
                <span class="time">${place.time}</span>
                <span class="place-type">
                  <c:choose>
                    <c:when test="${place.content_type_id == 1}">🏨 숙소</c:when>
                    <c:when test="${place.content_type_id == 2}">🍽 식당</c:when>
                    <c:otherwise>📍 장소</c:otherwise>
                  </c:choose>
                </span>
                <span class="place-name">${place.title}</span>
              </div>
              <c:if test="${not empty place.thumbnail}">
                <img src="${place.thumbnail}" class="place-image" alt="${place.title}">
              </c:if>
            </div>
          </c:forEach>
        </div>
      </c:forEach>
    </section>
  </main>

  <!-- Right Panel (Map Placeholder) -->
  <aside class="right-panel" id="rightPanel" style="display: none;">
    <!-- Map will be added here later -->
    <p>Map placeholder</p>
  </aside>
</div>

<script>
  // Simple JS to toggle between “전체일정” and a single day view
  document.addEventListener("DOMContentLoaded", function() {
    const dayButtons = document.querySelectorAll(".day-btn");
    const fullScheduleBtn = document.getElementById("fullScheduleBtn");
    const daySchedules = document.querySelectorAll(".day-schedule");
    const rightPanel = document.getElementById("rightPanel");

    function showFullSchedule() {
      dayButtons.forEach(btn => btn.classList.remove("active"));
      fullScheduleBtn.classList.add("active");
      daySchedules.forEach(schedule => schedule.style.display = "block");
      rightPanel.style.display = "none";
    }

    // Start by showing the full schedule
    showFullSchedule();

    dayButtons.forEach(btn => {
      btn.addEventListener("click", function() {
        dayButtons.forEach(b => b.classList.remove("active"));
        fullScheduleBtn.classList.remove("active");
        this.classList.add("active");
        const dayIndex = this.getAttribute("data-index");
        daySchedules.forEach(schedule => {
          schedule.style.display = (schedule.getAttribute("data-day-index") === dayIndex) ? "block" : "none";
        });
        rightPanel.style.display = "flex";
      });
    });

    fullScheduleBtn.addEventListener("click", showFullSchedule);

    // “내 일정에 담기” button – redirect to copy action
    const copyPlanBtn = document.getElementById("copyPlanBtn");
    if(copyPlanBtn) {
      copyPlanBtn.addEventListener("click", function() {
        // Pass along the current plan id (assumed stored as plan.idx)
        const planId = "${plan.idx}";
        window.location.href = "Controller?type=copyPlan&planId=" + planId;
      });
    }
  });
</script>
</body>
</html>