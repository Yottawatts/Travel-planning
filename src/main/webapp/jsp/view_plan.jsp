<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
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
    background-color: #D9F2FF; /* Light Blue Background */
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
    box-shadow: 0 2px 8px 0 rgba(31, 38, 135, .08) !important;
    width: 100%;
    background: none;
    border: none;
    padding: 10px;
    font-size: 16px;
    cursor: pointer;
    border-radius: 5px;
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

/* Trip Header */
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

    /* Schedule Item - Main Layout */
    .schedule-item {
        display: flex;
        align-items: center;
        justify-content: flex-start;
        padding: 15px 0;
        position: relative;
        gap: 15px;
        padding-bottom: ;
    }

    /* Time Column (Left-Aligned, Bold Like Image) */
    .time {
        font-size: 14px;
        color: #333;
        font-weight: bold;
        width: 80px;
        text-align: left;

    }

    /* Step Number (Red Circle, Now Left of Time) */
    .step-number {
        width: 18px;
        height: 18px;
        --tw-bg-opacity: 1;
        background-color: rgb(229 75 75 / var(--tw-bg-opacity));        --tw-text-opacity: 1;
        color: rgb(255 255 255 / var(--tw-text-opacity));
        font-size: .75rem;
        font-weight: bold;
        border-radius: 9999px;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
    }


    /* Time Column (Now Above Category) */
    .time-category {
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        text-align: left;
        gap: 3px;
    }

    /* Time Display */
    .time {
        font-size: 15px;
        font-weight: bold;
        --tw-text-opacity: 1;
        color: rgb(170 177 184 / var(--tw-text-opacity));
    }

    /* Place Type (Category) */
    .place-type {
        font-size: 12px;
        color: #007BFF;
        font-weight: bold;
    }

    /* Place Name */
    .place-name {
        font-size: 16px;
        font-weight: bold;
        color: #333;
    }

    /* Travel Time (🚗 + minutes, Properly Positioned) */
    .travel-time {
        display: flex;
        align-items: center;
        font-size: 14px;
        color: #777;
        padding-left: 40px;
        gap: 5px;
        justify-content: flex-start;
        margin-top: -5px;
    }

    /* Right-Aligned Image */
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
    background: #B3E0FF; /* Light Blue Placeholder */
    display: flex;
    align-items: center;
    justify-content: center;
    border-left: 1px solid #ddd;
}

</style>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>여행 일정</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
<div class="container">
  <!-- Left Sidebar -->
  <aside class="sidebar">
    <button class="full-schedule">전체일정</button>
    <nav class="days-nav">
      <button class="day-btn active">1일차</button>
      <button class="day-btn">2일차</button>
      <button class="day-btn">3일차</button>
      <button class="day-btn">4일차</button>
    </nav>
    <button class="save-btn">저장</button>
  </aside>

  <!-- Main Content -->
  <main class="main-content">
    <header class="trip-header">
      <h1>제주 <span class="date" id="duration">2025.2.10 - 2025.2.13</span></h1>
    </header>

    <!-- Itinerary Section -->
    <section class="itinerary">
      <!-- 1st Day Itinerary -->
      <div class="day-schedule">
        <h2>1일차 <span class="date">2025-02-10(월)</span></h2>

        <div class="schedule-item">
          <span class="step-number">1</span>
          <div class="time-category">
            <span class="time">14:15</span>
            <span class="place-type">📍 장소</span>
            <span class="place-name">제주국제공항</span>
          </div>
        </div>

        <div class="travel-time">
          🚗 <span>21분</span>
        </div>

        <div class="schedule-item">
          <span class="step-number">2</span>
          <div class="time-category">
            <span class="time">15:08</span>
            <span class="place-type">🏨 숙소</span>
            <span class="place-name">스위트호텔 제주</span>
          </div>
          <img src="hotel.jpg" class="place-image" alt="Hotel Image">
        </div>

        <div class="travel-time">
          🚗 <span>15분</span>
        </div>

        <div class="schedule-item">
          <span class="step-number">3</span>
          <div class="time-category">
            <span class="time">3:30 pm</span>
            <span class="place-type">📍 명소</span>
            <span class="place-name">새별오름</span>
          </div>
          <img src="saebyul.jpg" class="place-image" alt="Scenic Spot">
        </div>

        <div class="travel-time">
          🚗 <span>16분</span>
        </div>

        <div class="schedule-item">
          <span class="step-number">4</span>
          <div class="time-category">
            <span class="time">8:00 pm</span>
            <span class="place-type">📍 명소</span>
            <span class="place-name">성산 일출봉</span>
          </div>
          <img src="sunrise.jpg" class="place-image" alt="Seongsan Ilchulbong">
        </div>
      </div>






    </section>
  </main>

  <!-- Right Panel (Empty for Future Map Integration) -->
  <aside class="right-panel">
    <!-- Map Will Be Added Here Later -->
  </aside>
</div>
</body>
</html>

