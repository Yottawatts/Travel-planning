package action;

import mybatis.dao.PlanDAO;
import mybatis.vo.DateVO;
import mybatis.vo.PlanVO;
import org.json.JSONObject;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

import static mybatis.dao.PlanDAO.*;

public class CopyPlanAction implements Action {
  @Override
  public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
    // Check that the user is logged in.
    String sessionUserIdx = (String) request.getSession().getAttribute("user_idx");
    if (sessionUserIdx == null) {
      // Redirect to login page if not logged in.
      return "/jsp/login.jsp";
    }

    String planId = request.getParameter("planId");
    PlanVO origPlan = getPlanById(planId);
    if (origPlan == null) {
      request.setAttribute("error", "Plan not found.");
      return "/jsp/error.jsp";
    }

    // If the logged-in user is the owner, do not allow copying.
    if (sessionUserIdx.equals(origPlan.getUser_idx())) {
      return "Controller?type=viewPlan&planId=" + planId;
    }

    // Check if the new start/end dates are provided.
    String newStartDate = request.getParameter("newStartDate");
    String newEndDate = request.getParameter("newEndDate");
    if (newStartDate == null || newEndDate == null) {
      // Forward to date picker if dates are not yet provided.
      request.setAttribute("plan", origPlan);
      return "date_picker2.jsp";
    }

    // Copy the plan with the new date range.
    int newPlanId = PlanDAO.copyPlan(planId, sessionUserIdx, newStartDate, newEndDate);

    // Redirect to view the newly copied plan.
    return "Controller?type=viewPlan&planId=" + newPlanId;
  }

  // public static int copyPlan(String origPlanId, String newUserIdx, String newStartDate, String newEndDate) {
  //   // Retrieve original plan details.
  //   PlanVO origPlan = getPlanById(origPlanId);
  //   if (origPlan == null) return -1;
  //
  //   // Parse the new start and end dates.
  //   LocalDate newStart = LocalDate.parse(newStartDate); // Assumes format yyyy-MM-dd
  //   LocalDate newEnd = LocalDate.parse(newEndDate);
  //
  //   // Calculate the number of days in the new plan (inclusive).
  //   long newDays = ChronoUnit.DAYS.between(newStart, newEnd) + 1;
  //   List<DateVO> origDates = origPlan.getDateList();
  //   int origDays = origDates.size();
  //
  //   // (Assume the date range is valid – i.e. newDays equals origDays.)
  //
  //   // Create a new plan with the new date range.
  //   PlanVO newPlan = new PlanVO();
  //   newPlan.setUser_idx(newUserIdx);
  //   newPlan.setArea_code(origPlan.getArea_code());
  //   newPlan.setTitle(origPlan.getTitle());
  //   newPlan.setStart_date(newStartDate);
  //   newPlan.setEnd_date(newEndDate);
  //   newPlan.setStatus("0");
  //
  //   // Insert the new plan.
  //   int newPlanId = insertPlan(newPlan);
  //
  //   // Loop through each date of the original plan.
  //   for (int i = 0; i < origDays; i++) {
  //     // Calculate the new date by adding i days to the new start date.
  //     LocalDate currentNewDate = newStart.plusDays(i);
  //     String newDateStr = currentNewDate.toString(); // Format: yyyy-MM-dd
  //     // Insert the new date into the date_table.
  //     int newDateId = insertDate(newPlanId, newDateStr);
  //
  //     // Get the list of places for the current original date.
  //     List<mybatis.vo.PlaceVO> places = origDates.get(i).getPlaceList();
  //     for (int j = 0; j < places.size(); j++) {
  //       mybatis.vo.PlaceVO origPlace = places.get(j);
  //
  //       // Convert the PlaceVO into a JSONObject matching the expected keys.
  //       JSONObject placeJson = new JSONObject();
  //       placeJson.put("content_id", origPlace.getContent_id());
  //       // Convert content_type_id from String to int.
  //       placeJson.put("content_type_id", Integer.parseInt(origPlace.getContent_type_id()));
  //       placeJson.put("title", origPlace.getTitle());
  //       placeJson.put("thumbnail", origPlace.getThumbnail());
  //       // Convert map_x and map_y from String to double.
  //       placeJson.put("map_x", Double.parseDouble(origPlace.getMap_x()));
  //       placeJson.put("map_y", Double.parseDouble(origPlace.getMap_y()));
  //       placeJson.put("time", origPlace.getTime());
  //
  //       // Insert the place into place_table.
  //       boolean success = insertPlace(newPlanId, newDateId, j + 1, placeJson);
  //       // (Assume success; error handling can be added as needed.)
  //     }
  //   }
  //   return newPlanId;
  // }
}