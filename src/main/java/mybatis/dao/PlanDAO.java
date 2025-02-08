package mybatis.dao;

import mybatis.service.FactoryService;
import mybatis.vo.PlaceVO;
import mybatis.vo.PlanVO;
import mybatis.vo.DateVO;
import org.apache.ibatis.session.SqlSession;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;
import java.util.List;

public class PlanDAO {

  // Insert into plan_table
  public static int insertPlan(PlanVO plan) {
    if (plan.getUser_idx() == null || plan.getArea_code() == null) {
      return -1; // Validation check
    }

    try (SqlSession ss = FactoryService.getFactory().openSession()) {
      int cnt = ss.insert("plan.insertPlan", plan);
      System.out.println("Inserting plan with user_idx: " + plan.getUser_idx() + " and area_code: " + plan.getArea_code());

      if (cnt > 0) {
        ss.commit();
        return Integer.parseInt(plan.getIdx()); // Get auto-generated plan_idx
      } else {
        ss.rollback();
      }
    }
    return -1;
  }

  // Insert into date_table
  public static int insertDate(int planIdx, String date) {
    try (SqlSession ss = FactoryService.getFactory().openSession()) {
      Map<String, Object> param = new HashMap<>();
      param.put("plan_idx", planIdx);
      param.put("date", date);

      int cnt = ss.insert("plan.insertDate", param);
      if (cnt > 0) {
        ss.commit();
        System.out.println("Inserted date with param: " + param);
        return (Integer) param.get("idx"); // Auto-generated ID
      } else {
        ss.rollback();
      }
    }
    return -1;
  }

  // Insert into place_table (original method)
  public static boolean insertPlace(int dateIdx, int order, JSONObject place) {
    try (SqlSession ss = FactoryService.getFactory().openSession()) {
      Map<String, Object> param = new HashMap<>();
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
    }
    return false;
  }

  // Retrieve the full plan (with dates and places) by plan id.
  public static PlanVO getPlanById(int planId) {
    try (SqlSession ss = FactoryService.getFactory().openSession()) {
      return ss.selectOne("plan.getPlanById", planId);
    }
  }

  // Copy a plan (for "내 일정에 담기") by inserting a new plan and then
  // copying its dates and places.
  public static int copyPlan(PlanVO originalPlan, String newStartDate, String newEndDate, String newUserId) {
    PlanVO newPlan = new PlanVO();
    newPlan.setUser_idx(newUserId);
    newPlan.setArea_code(originalPlan.getArea_code());
    newPlan.setTitle(originalPlan.getTitle() + " - 복사본");
    newPlan.setStart_date(newStartDate);
    newPlan.setEnd_date(newEndDate);
    newPlan.setStatus("0");

    int newPlanIdx = insertPlan(newPlan);
    if (newPlanIdx == -1) return -1;

    List<DateVO> originalDates = originalPlan.getDate_idx();
    if (originalDates != null) {
      for (DateVO dateVO : originalDates) {
        int newDateIdx = insertDate(newPlanIdx, dateVO.getDate());
        if (newDateIdx == -1) return -1;

        List<PlaceVO> places = dateVO.getPlace_idx();
        if (places != null) {
          int order = 1;
          for (PlaceVO placeVO : places) {
            boolean success = insertPlace2(newPlanIdx, newDateIdx, order, placeVO);
            if (!success) return -1;
            order++;
          }
        }
      }
    }
    return newPlanIdx;
  }

  // NEW insertPlace2 (using PlaceVO) - SAFE AND SEPARATE
  public static boolean insertPlace2(int planIdx, int dateIdx, int order, PlaceVO place) {
    try (SqlSession ss = FactoryService.getFactory().openSession()) {
      Map<String, Object> param = new HashMap<>();
      param.put("plan_idx", planIdx);
      param.put("date_idx", dateIdx);
      param.put("visit_order", order);
      param.put("content_id", place.getContent_id());
      param.put("content_type_id", Integer.parseInt(place.getContent_type_id())); // Convert String -> int
      param.put("title", place.getTitle());
      param.put("thumbnail", place.getThumbnail());
      param.put("map_x", Double.parseDouble(place.getMap_x())); // Convert String -> double
      param.put("map_y", Double.parseDouble(place.getMap_y())); // Convert String -> double
      param.put("time", place.getTime());

      int cnt = ss.insert("plan.insertPlace", param);
      if (cnt > 0) {
        ss.commit();
        return true;
      } else {
        ss.rollback();
      }
    } catch (NumberFormatException e) {
      e.printStackTrace();
    }
    return false;
  }
}
