<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>여행 플래너</title>
  <style>
      body {
          margin: 0;
          font-family: 'Noto Sans KR', sans-serif;
          display: flex;
          height: 100vh;
          color: #333;
      }
      .content-wrapper {
          display: flex;
          width: 100%;
          height: 100%;
      }

      /* --- Left Panel --- */
      #left-panel {
          width: 12%;
          background-color: #fff;
          border-right: 1px solid #ddd;
          display: flex;
          flex-direction: column;
          align-items: center;
          padding: 15px;
      }
      #logo {
          font-size: 22px;
          font-weight: bold;
          color: #f56b2a;
          margin-bottom: 20px;
      }
      .date {
          margin-bottom: 8px;
          padding: 8px 12px;
          border-radius: 5px;
          background-color: #f5f5f5;
          text-align: center;
          cursor: pointer;
      }
      .date.active {
          background-color: #f56b2a;
          color: white;
          font-weight: bold;
      }
      .date:hover {
          background-color: #eaeaea;
      }

      /* --- Middle-Left Panel (List of destinations) --- */
      #middle-left-panel {
          width: 18%;
          background-color: #f9f9f9;
          display: flex;
          flex-direction: column;
          padding: 15px;
      }
      #destination-header {
          font-size: 18px;
          font-weight: bold;
          margin-bottom: 5px;
      }
      #destination-date-range {
          font-size: 14px;
          color: #666;
          margin-bottom: 20px;
      }
      .categories {
          display: flex;
          gap: 10px;
          margin-bottom: 15px;
      }
      .category {
          display: flex;
          align-items: center;
          gap: 5px;
          padding: 5px 10px;
          background-color: #f5f5f5;
          border-radius: 5px;
          cursor: pointer;
      }
      .category:hover {
          background-color: #eaeaea;
      }
      #search-bar {
          display: flex;
          margin-bottom: 15px;
      }
      #search-bar input {
          flex-grow: 1;
          padding: 8px;
          border: 1px solid #ddd;
          border-radius: 5px;
          margin-right: 10px;
      }
      #search-bar button {
          padding: 8px 15px;
          background-color: #007bff;
          color: white;
          border: none;
          border-radius: 5px;
          cursor: pointer;
      }
      #search-bar button:hover {
          background-color: #0056b3;
      }
      #destination-list {
          flex-grow: 1;
          overflow-y: auto;
      }
      .destination {
          display: flex;
          align-items: center;
          margin-bottom: 10px;
          padding: 10px;
          background-color: #fff;
          border: 1px solid #ddd;
          border-radius: 5px;
          cursor: pointer;
      }
      .destination img {
          width: 50px;
          height: 50px;
          margin-right: 10px;
          border-radius: 5px;
      }
      .destination-info {
          flex-grow: 1;
      }
      .destination-info h4 {
          margin: 0;
          font-size: 16px;
          font-weight: bold;
      }
      .destination-info p {
          margin: 5px 0 0;
          font-size: 12px;
          color: #666;
      }
      .destination-info .ratings {
          display: flex;
          align-items: center;
          font-size: 12px;
          color: #666;
          margin-top: 5px;
      }
      .ratings span {
          margin-left: 5px;
      }
      .heart {
          font-size: 18px;
          color: #f44336;
          cursor: pointer;
      }
      .add-button {
          font-size: 16px;
          color: #007bff;
          cursor: pointer;
          margin-left: 10px;
      }

      /* --- Middle Panel (Selected places & reorder) --- */
      #middle-panel {
          width: 18%;
          background-color: #f9f9f9;
          display: flex;
          flex-direction: column;
          padding: 15px;
      }
      #time-summary {
          font-size: 14px;
          margin-bottom: 10px;
          font-weight: bold;
      }
      #clear-button {
          align-self: flex-end;
          margin-bottom: 15px;
          padding: 8px 12px;
          background-color: #f44336;
          color: white;
          border: none;
          border-radius: 5px;
          cursor: pointer;
      }
      #clear-button:hover {
          background-color: #d32f2f;
      }
      #selected-places {
          display: flex;
          flex-direction: column;
          gap: 10px;
      }
      .selected-place {
          display: flex;
          align-items: center;
          padding: 10px;
          background-color: #fff;
          border: 1px solid #ddd;
          border-radius: 10px;
          box-shadow: 0 2px 5px rgba(0,0,0,0.1);
          cursor: grab; /* show grab cursor */
      }
      .selected-place.dragging {
          opacity: 0.6; /* dim while dragging */
      }
      .number {
          width: 30px;
          height: 30px;
          border-radius: 50%;
          background-color: #0083ff;
          display: flex;
          align-items: center;
          justify-content: center;
          color: #fff;
          font-size: 14px;
          margin-right: 10px;
      }
      .selected-place img {
          width: 48px;
          height: 48px;
          margin-right: 10px;
          border-radius: 5px;
      }
      .selected-place .info {
          flex-grow: 1;
          display: flex;
          flex-direction: column;
          gap: 3px;
      }
      .selected-place .info h4 {
          margin: 0;
          font-size: 15px;
          font-weight: bold;
      }
      .selected-place .info p {
          margin: 0;
          color: #666;
          font-size: 12px;
      }
      .time-picker {
          width: 75px;
          margin-right: 10px;
          font-size: 14px;
      }
      .delete {
          font-size: 16px;
          color: #f44336;
          cursor: pointer;
      }

      /* --- Right Panel (Map) --- */
      #right-panel {
          flex-grow: 1; /* take remaining space */
          background-color: #eaeaea;
          position: relative;
      }
      #map {
          width: 100%;
          height: 100%;
          background-color: #eaeaea; /* Placeholder for map */
      }
      #floating-button {
          position: absolute;
          top: 10px;
          right: 10px;
          background-color: #007bff;
          color: white;
          border: none;
          padding: 8px 12px;
          border-radius: 5px;
          cursor: pointer;
      }
      #floating-button:hover {
          background-color: #0056b3;
      }
      #action-buttons {
          display: flex;
          justify-content: space-between;
          margin-top: 20px;
      }
      .action-button {
          flex: 1;
          margin: 0 5px;
          padding: 10px;
          background-color: #007bff;
          color: white;
          border: none;
          border-radius: 5px;
          cursor: pointer;
          font-size: 16px;
      }
      .action-button:hover {
          background-color: #0056b3;
      }
  </style>
</head>
<body>
<div class="content-wrapper">

  <!-- Left Panel -->
  <div id="left-panel">
    <div id="logo">zenzenclub</div>
    <div id="date-container"></div> <!-- Dates will be added dynamically -->
    <div id="action-buttons">
      <button class="action-button" onclick="savePlan()">저장</button>
    </div>
  </div>

  <!-- Middle-Left Panel (Destination List) -->
  <div id="middle-left-panel">
    <div id="destination-header">서울</div>
    <div id="destination-date-range">2025-01-14 ~ 2025-01-20</div>
    <div class="categories">
      <div class="category">🍴 음식</div>
      <div class="category">☕ 카페</div>
      <div class="category">❤️ 하트</div>
    </div>
    <div id="search-bar">
      <input type="text" placeholder="장소를 입력해주세요.">
      <button>검색</button>
    </div>
    <div id="destination-list"></div>
    <div id="action-buttons">
      <button class="action-button">숙소 선택</button>
    </div>
  </div>

  <!-- Middle Panel (Selected Places) -->
  <div id="middle-panel">
    <div id="time-summary">3 / 6시간 0분 / 24시간 0분</div>
    <button id="clear-button">장소 설정 초기화</button>
    <!-- Container for selected places -->
    <div id="selected-places"></div>
  </div>

  <!-- Right Panel -->
  <div id="right-panel">
    <div id="map">맵</div>
    <button id="floating-button">이용방법</button>
  </div>

</div>

<script>
  // GLOBAL array to store the current plan (so we can reorder, limit to 10, etc.)
  let currentPlan = [];
  const allDates = [];
  const selectedPlace = [];
  // Declare `planData` globally
  let planData = {
    user_idx: sessionStorage.getItem("user_idx") || "1",
    area_code: sessionStorage.getItem("area_code") || "1",
    title: "",
    start_date: sessionStorage.getItem("startDate"),
    end_date: sessionStorage.getItem("endDate"),
    status: 0,
    dates: {} // Initialize an empty object to store dates
  };

  function generateDateRange(startDate, endDate) {
    const start = new Date(startDate);
    const end = new Date(endDate);
    const dates = [];

    while (start <= end) {
      // Format the date as YYYY-MM-DD
      dates.push(start.toISOString().split('T')[0]);
      start.setDate(start.getDate() + 1);
    }

    return dates;
  }

  document.addEventListener("DOMContentLoaded", function() {
    fetchTouristSpots();
    setupDragAndDrop();
    initializeDates();
  });

  // Store previous date selection
  let previousDate = null;
  let selectedDate = null;

  // Function to generate date range from session storage
  function initializeDates() {
    const startDate = sessionStorage.getItem("startDate");
    const endDate = sessionStorage.getItem("endDate");
    console.log("Stored start date:", sessionStorage.getItem("startDate"));
    console.log("Stored end date:", sessionStorage.getItem("endDate"));


    if (!startDate || !endDate) {
      console.error("Start date or end date missing from session storage.");
      return;
    }

    const dateContainer = document.getElementById("date-container");
    dateContainer.innerHTML = "";

    const allDates = generateDateRange(startDate, endDate);

    allDates.forEach((date, index) => {
      const dateElement = document.createElement("div");
      dateElement.classList.add("date");
      dateElement.textContent = date;

      if (index === 0) {
        dateElement.classList.add("active"); // Default to first date
        selectedDate = date;
      }

      dateElement.addEventListener("click", function() {
        selectDate(date, dateElement);
      });

      dateContainer.appendChild(dateElement);
    });

    updateSelectedPlaces(selectedDate);
  }

  // Function to handle date selection
  function selectDate(date, element) {
    if (selectedDate) {
      // Save the current plan to `planData.dates[selectedDate]`
      planData.dates[selectedDate] = [...currentPlan]; // Store a copy
    }

    previousDate = selectedDate;
    selectedDate = date;

    // Update active class
    document.querySelectorAll(".date").forEach(d => d.classList.remove("active"));
    element.classList.add("active");

    console.log("Previous Date:", previousDate, "Selected Date:", selectedDate);

    // Load saved places for the new date, or initialize an empty array
    currentPlan = planData.dates[selectedDate] || [];

    // Update UI
    updateSelectedPlaces(selectedDate);
  }


  // Function to update selected places based on selectedDate
  function updateSelectedPlaces(date) {
    const container = document.getElementById("selected-places");
    container.innerHTML = "";

    const placesForDate = currentPlan.filter(place => place.date === date);

    if (placesForDate.length === 0) {
      container.innerHTML = `<p>장소 추가하기</p>`;
    } else {
      renderSelectedPlaces(placesForDate);
    }
  }

  // Ensure adding places saves them under selectedDate
  function addPlaceToPlan(place) {
    if (currentPlan.length >= 10) {
      alert("이미 10개 장소가 선택되었습니다. 더 이상 추가할 수 없습니다.");
      return;
    }

    if (!selectedDate) {
      alert("날짜가 선택되지 않았습니다.");
      return;
    }

    place.date = selectedDate;

    // Save place under the correct date in planData.dates
    if (!planData.dates[selectedDate]) {
      planData.dates[selectedDate] = [];
    }

    planData.dates[selectedDate].push(place);
    currentPlan.push(place);
    updateSelectedPlaces(selectedDate);
  }



  /////
  // 1) Fetch your list of tourist spots
  function fetchTouristSpots() {
    fetch('/Controller?type=getTouristSpots')
        .then(response => response.json())
        .then(data => displayPlaces(data))
        .catch(error => console.error('Error fetching data:', error));
  }

  // 2) Display them in the "destination-list" (left panel)
  function displayPlaces(places) {
    const destinationList = document.getElementById("destination-list");
    destinationList.innerHTML = "";

    places.forEach(function(place) {
      const imgSrc = place.image ? place.image : "https://via.placeholder.com/50";
      const shortAddress = place.address;

      const listItem = document.createElement("div");
      listItem.classList.add("destination");
      listItem.dataset.lat = place.mapy;
      listItem.dataset.lon = place.mapx;
      listItem.dataset.category = place.category;
      listItem.dataset.contentid = place.contentid;

      // Build the inner HTML
      listItem.innerHTML =
          '<img src="' + imgSrc + '" alt="thumbnail">' +
          '<div class="destination-info">' +
          '<h4>' + place.title + '</h4>' +
          '<p>' + shortAddress + '</p>' +
          '<div class="ratings">⭐ <span>4.5</span></div>' +
          '</div>' +
          '<span class="heart">♥</span>' +
          '<span class="add-button">+</span>';

      destinationList.appendChild(listItem);

      // "+" button adds to our plan
      const addButton = listItem.querySelector(".add-button");
      addButton.addEventListener("click", function(e) {
        e.stopPropagation();
        addPlaceToPlan(place);
      });
    });
  }

  // 3) Add to plan, with limit of 10



  // 4) Render selected places in the middle panel
  function renderSelectedPlaces(planArray) {
    const container = document.getElementById("selected-places");
    container.innerHTML = "";

    planArray.forEach((spot, index) => {
      const imgSrc = spot.image || "https://via.placeholder.com/50";
      const div = document.createElement("div");
      div.classList.add("selected-place");
      div.setAttribute("draggable", "true"); // for reordering
      // store the index so we can reorder currentPlan
      div.dataset.index = index;

      // Build the item layout
      div.innerHTML =
          '<div class="number">' + (index + 1) + '</div>' +
          '<img src="' + imgSrc + '" alt="thumbnail">' +
          '<div class="info">' +
          '<h4>' + spot.title + '</h4>' +
          '<p>' + spot.address + '</p>' +
          '</div>' +
          '<input type="time" class="time-picker" ' + (spot.time ? 'value="' + spot.time + '"' : 'value="00:00"') + '>' +
          '<span class="delete">🗑</span>';

      // Keep the time in sync with our array
      const timeInput = div.querySelector(".time-picker");
      timeInput.addEventListener("change", (e) => {
        // store the time in the spot object
        spot.time = e.target.value;
      });

      // Delete from plan
      const deleteBtn = div.querySelector(".delete");
      deleteBtn.addEventListener("click", function() {
        removePlaceFromPlan(index);
      });

      container.appendChild(div);
    });
  }

  function removePlaceFromPlan(indexToRemove) {
    // For example, call server to remove from session if needed
    // Then update local array
    currentPlan.splice(indexToRemove, 1);
    renderSelectedPlaces(currentPlan);
  }

  // 5) Drag & Drop setup
  function setupDragAndDrop() {
    const container = document.getElementById("selected-places");
    let draggedEl = null;

    // dragstart
    container.addEventListener("dragstart", (e) => {
      if (e.target.classList.contains("selected-place")) {
        draggedEl = e.target;
        draggedEl.classList.add("dragging");
        // set data transfer if needed
        e.dataTransfer.setData("text/plain", e.target.dataset.index);
      }
    });

    // dragover
    container.addEventListener("dragover", (e) => {
      e.preventDefault(); // allow drop
      const afterElement = getDragAfterElement(container, e.clientY);
      if (draggedEl && afterElement === null) {
        container.appendChild(draggedEl);
      } else if (draggedEl && afterElement) {
        container.insertBefore(draggedEl, afterElement);
      }
    });

    // dragend
    container.addEventListener("dragend", (e) => {
      if (draggedEl) {
        draggedEl.classList.remove("dragging");
        // Re-build currentPlan array based on new DOM order
        const newOrderEls = [...container.querySelectorAll(".selected-place")];
        const newPlan = [];
        newOrderEls.forEach((el) => {
          // old index
          const oldIndex = parseInt(el.dataset.index, 10);
          newPlan.push(currentPlan[oldIndex]);
        });
        currentPlan = newPlan;

        // Re-render so the numbers get updated
        renderSelectedPlaces(currentPlan);
        draggedEl = null;
      }
    });

    // figure out what element is just after the drag position
    function getDragAfterElement(container, y) {
      const nonDragged = [...container.querySelectorAll(".selected-place:not(.dragging)")];

      let closest = null;
      let closestOffset = Number.NEGATIVE_INFINITY;
      nonDragged.forEach(child => {
        const box = child.getBoundingClientRect();
        const offset = y - (box.top + box.height / 2);
        // offset < 0 means the mouse is above this child
        if (offset < 0 && offset > closestOffset) {
          closestOffset = offset;
          closest = child;
        }
      });
      return closest;
    }
  }

  // 6) Clear the entire plan
  document.getElementById("clear-button").addEventListener("click", function() {
    currentPlan = [];
    renderSelectedPlaces(currentPlan);
  });

  // // 7) Save plan (you can send the updated currentPlan to your server)

  function savePlan() {
    if (currentPlan.length === 0) {
      alert("여행 계획을 추가하세요.");
      return;
    }

    // // Fetch session data
    // const user_idx = sessionStorage.getItem("user_idx") || "1";
    // const area_code = sessionStorage.getItem("area_code") || "1";
    // const start_date = sessionStorage.getItem("startDate");
    // const end_date = sessionStorage.getItem("endDate");
    // const title = prompt("여행 계획 제목을 입력하세요:");
    //
    // if (!title) return;
// Fetch session data
    const start_date = sessionStorage.getItem("startDate");
    const end_date = sessionStorage.getItem("endDate");
    planData.title = prompt("여행 계획 제목을 입력하세요:");
    if (!planData.title) return;

    // Check if start_date and end_date are available
    if (!start_date || !end_date) {
      alert("여행 시작일과 종료일이 필요합니다.");
      return;
    }

    // Generate all dates between start_date and end_date
    const allDates = generateDateRange(start_date, end_date);
    console.log("Generated Date Range:", allDates);

    // // Convert plan to structured format
    // const planData = {
    //   user_idx: user_idx,
    //   area_code: area_code,
    //   title: title,
    //   start_date: start_date,
    //   end_date: end_date,
    //   status: 0,
    //   dates: {} // Will be populated with places for each date
    // };
    //
    // // Initialize empty arrays for each date in the date range
    // allDates.forEach(date => {
    //   planData.dates[date] = []; // Initialize an empty array for each date
    // });
// Initialize empty arrays for each date in the date range
    allDates.forEach(date => {
      if (!planData.dates[date]) planData.dates[date] = [];
    });


    // Populate the dates with the places from currentPlan
    currentPlan.forEach(place => {
      const dateKey = place.date; // This will be set in addPlaceToPlan
      if (planData.dates[dateKey]) {
        planData.dates[dateKey].push({
          content_id: place.contentid,
          content_type_id: 1,
          title: place.title,
          thumbnail: place.image,
          map_x: place.mapx,
          map_y: place.mapy,
          time: place.time || "00:00"
        });
      }
    });

    // Ensure the dates object is correctly populated
    console.log("Plan data to be sent:", JSON.stringify(planData));

    // Send planData to the server
    fetch("/Controller?type=savePlan", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(planData)
    })
        .then(response => response.json())  // Convert response to text first

        // .then(text => {
        //   console.log("Raw server response:", text); // Check the response
        //   return JSON.parse(text); // Then try parsing JSON
        // })
        .then(data => {
          data.json()
          console.log("Parsed JSON response:", data);
          if (data.success) {
            alert("여행 계획이 저장되었습니다!");
          } else {
            alert("저장 실패: " + data.error);
          }
        })
        .catch(error => {
          console.error("Error:", error);
          alert("서버와의 연결에서 문제가 발생했습니다.");
        });

  }

</script>
</body>
</html>
