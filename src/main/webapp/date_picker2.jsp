<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>날짜 범위 선택</title>
  <script>
    function updateEndDate() {
      var startDate = document.getElementById('newStartDate').value;
      if (startDate) {
        var numDays = parseInt(document.getElementById('numDays').value);
        var date = new Date(startDate);
        date.setDate(date.getDate() + numDays - 1);
        var dd = String(date.getDate()).padStart(2, '0');
        var mm = String(date.getMonth() + 1).padStart(2, '0'); // JavaScript month is 0-based.
        var yyyy = date.getFullYear();
        var endDate = yyyy + '-' + mm + '-' + dd;
        document.getElementById('newEndDate').value = endDate;
      }
    }
  </script>
</head>
<body>
<h2>새로운 날짜 범위를 선택하세요</h2>
<form action="Controller" method="get">
  <!-- Specify the copyPlan action -->
  <input type="hidden" name="type" value="copyPlan">
  <input type="hidden" name="planId" value="${plan.idx}">
  <!-- Pass the number of days from the original plan -->
  <input type="hidden" id="numDays" value="${fn:length(plan.dateList)}">

  <label for="newStartDate">시작일:</label>
  <input type="date" id="newStartDate" name="newStartDate" onchange="updateEndDate()" required>
  <br><br>
  <label for="newEndDate">종료일:</label>
  <!-- The end date is computed automatically -->
  <input type="date" id="newEndDate" name="newEndDate" readonly required>
  <br><br>
  <button type="submit">저장</button>
</form>
</body>
</html>