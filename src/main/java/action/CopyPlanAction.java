package action;

import mybatis.dao.PlanDAO;
import mybatis.vo.PlanVO;
import org.json.JSONObject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class CopyPlanAction implements Action {
  @Override
  public String execute(HttpServletRequest request, HttpServletResponse response) throws IOException {
    // Read JSON from request body.
    StringBuilder sb = new StringBuilder();
    BufferedReader reader = request.getReader();
    String line;
    while((line = reader.readLine()) != null){
      sb.append(line);
    }
    JSONObject requestData = new JSONObject(sb.toString());

    HttpSession session = request.getSession();
    String sessionUserId = (String) session.getAttribute("user_idx");
    if(sessionUserId == null || sessionUserId.isEmpty()){
      return jsonResponse(response, false, "로그인이 필요합니다.", null);
    }

    int planId = requestData.getInt("planId");
    String newStartDate = requestData.getString("start_date");
    String newEndDate = requestData.getString("end_date");

    PlanVO originalPlan = PlanDAO.getPlanById(planId);
    if(originalPlan == null){
      return jsonResponse(response, false, "원본 계획을 찾을 수 없습니다.", null);
    }

    if(sessionUserId.equals(originalPlan.getUser_idx())){
      return jsonResponse(response, false, "자신의 계획은 복사할 수 없습니다.", null);
    }

    // (Optional: validate that the new date range has the same number of days as the original.)
    int newPlanId = PlanDAO.copyPlan(originalPlan, newStartDate, newEndDate, sessionUserId);
    if(newPlanId == -1){
      return jsonResponse(response, false, "계획 복사에 실패하였습니다.", null);
    }
    return jsonResponse(response, true, null, newPlanId);
  }

  private String jsonResponse(HttpServletResponse response, boolean success, String error, Integer newPlanId) throws IOException {
    response.setContentType("application/json; charset=UTF-8");
    Map<String, Object> resMap = new HashMap<>();
    resMap.put("success", success);
    if(error != null){
      resMap.put("error", error);
    }
    if(newPlanId != null){
      resMap.put("newPlanId", newPlanId);
    }
    response.getWriter().write(new JSONObject(resMap).toString());
    return null;
  }
}
