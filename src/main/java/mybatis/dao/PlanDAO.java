package mybatis.dao;

import mybatis.service.FactoryService;
import mybatis.vo.DateVO;
import mybatis.vo.PlaceVO;
import mybatis.vo.PlanVO;
import org.apache.ibatis.session.SqlSession;
import org.json.JSONObject;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PlanDAO {

  // Inserts a new plan into plan_table and returns the generated plan ID.
  public static int insertPlan(PlanVO plan) {
    // Validate that user_idx and area_code are provided.
    if (plan.getUser_idx() == null || plan.getArea_code() == null) {
      return -1;
    }
    try (SqlSession ss = FactoryService.getFactory().openSession()) {
      int cnt = ss.insert("plan.insertPlan", plan);
      if (cnt > 0) {
        ss.commit();
        // Assumes that MyBatis sets plan.idx (as a String) with the auto-generated ID.
        return Integer.parseInt(plan.getIdx());
      } else {
        ss.rollback();
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return -1;
  }

  // Inserts a new date into date_table for the given plan and returns the generated date ID.
  public static int insertDate(int planIdx, String date) {
    try (SqlSession ss = FactoryService.getFactory().openSession()) {
      Map<String, Object> param = new HashMap<>();
      param.put("plan_idx", planIdx);
      param.put("date", date);
      int cnt = ss.insert("plan.insertDate", param);
      if (cnt > 0) {
        ss.commit();
        // Assumes MyBatis returns the generated key in param under the key "idx".
        return (Integer) param.get("idx");
      } else {
        ss.rollback();
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return -1;
  }

  // Inserts a new place into place_table using a JSON object and returns true if successful.
  public static boolean insertPlace(int planIdx, int dateIdx, int order, JSONObject place) {
    try (SqlSession ss = FactoryService.getFactory().openSession()) {
      Map<String, Object> param = new HashMap<>();
      param.put("plan_idx", planIdx);
      param.put("date_idx", dateIdx);
      param.put("visit_order", order);
      param.put("content_id", place.getString("content_id"));
      param.put("content_type_id", place.getInt("content_type_id"));
      param.put("title", place.getString("title"));
      param.put("thumbnail", place.getString("thumbnail"));
      param.put("map_x", place.getDouble("map_x"));
      param.put("map_y", place.getDouble("map_y"));
      param.put("time", place.getString("time"));

      int cnt = ss.insert("plan.insertPlace", param);
      if (cnt > 0) {
        ss.commit();
        return true;
      } else {
        ss.rollback();
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return false;
  }

  // Retrieves a plan by its ID, and for that plan, also retrieves its associated dates and places.
  public static PlanVO getPlanById(String planId) {
    try (SqlSession ss = FactoryService.getFactory().openSession()) {
      // Retrieve the main plan data.
      PlanVO plan = ss.selectOne("plan.getPlanById", planId);
      if (plan != null) {
        // Retrieve all dates associated with the plan.
        List<DateVO> dateList = ss.selectList("plan.getDatesByPlanId", planId);
        for (DateVO date : dateList) {
          // For each date, retrieve all associated places.
          List<PlaceVO> placeList = ss.selectList("plan.getPlacesByDateId", date.getIdx());
          date.setPlaceList(placeList);  // Assumes DateVO has a setter for placeList.
        }
        plan.setDateList(dateList); // Assumes PlanVO has a setter for dateList.
      }
      return plan;
    } catch (Exception e) {
      e.printStackTrace();
    }
    return null;
  }

  // Copies an existing plan (including its dates and places) for a new user with adjusted dates.
  // newStartDate and newEndDate must cover exactly the same number of days as the original plan.
  public static int copyPlan(String origPlanId, String newUserIdx, String newStartDate, String newEndDate) {
    // Retrieve the original plan details.
    PlanVO origPlan = getPlanById(origPlanId);
    if (origPlan == null) return -1;

    // Parse the new start and end dates.
    LocalDate newStart = LocalDate.parse(newStartDate);
    LocalDate newEnd = LocalDate.parse(newEndDate);
    long newDays = ChronoUnit.DAYS.between(newStart, newEnd) + 1;
    List<DateVO> origDates = origPlan.getDateList();
    int origDays = origDates.size();

    // Ensure the new date range length matches the number of dates in the original plan.
    if (newDays != origDays) {
      System.err.println("The new date range does not match the number of dates in the original plan.");
      return -1;
    }

    // Create and insert the new plan.
    PlanVO newPlan = new PlanVO();
    newPlan.setUser_idx(newUserIdx);
    newPlan.setArea_code(origPlan.getArea_code());
    newPlan.setTitle(origPlan.getTitle());
    newPlan.setStart_date(newStartDate);
    newPlan.setEnd_date(newEndDate);
    newPlan.setStatus("0");

    int newPlanId = insertPlan(newPlan);
    if (newPlanId == -1) return -1;

    // For each date in the original plan, calculate the corresponding new date,
    // insert it, and then copy all associated places.
    for (int i = 0; i < origDays; i++) {
      LocalDate currentNewDate = newStart.plusDays(i);
      String newDateStr = currentNewDate.toString();
      int newDateId = insertDate(newPlanId, newDateStr);
      if (newDateId == -1) return -1;

      List<PlaceVO> origPlaces = origDates.get(i).getPlaceList();
      for (int j = 0; j < origPlaces.size(); j++) {
        PlaceVO origPlace = origPlaces.get(j);
        JSONObject placeJson = new JSONObject();
        placeJson.put("content_id", origPlace.getContent_id());
        // Convert content_type_id to int if it is stored as a String.
        placeJson.put("content_type_id", Integer.parseInt(origPlace.getContent_type_id()));
        placeJson.put("title", origPlace.getTitle());
        placeJson.put("thumbnail", origPlace.getThumbnail());
        // Convert map_x and map_y to double if they are stored as Strings.
        placeJson.put("map_x", Double.parseDouble(origPlace.getMap_x()));
        placeJson.put("map_y", Double.parseDouble(origPlace.getMap_y()));
        placeJson.put("time", origPlace.getTime());

        boolean success = insertPlace(newPlanId, newDateId, j + 1, placeJson);
        if (!success) return -1;
      }
    }
    return newPlanId;
  }
}