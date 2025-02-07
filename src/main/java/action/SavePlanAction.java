package action;

import com.google.gson.Gson;
import mybatis.dao.PlanDAO;
import mybatis.vo.PlanVO;
import org.json.JSONArray;
import org.json.JSONObject;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class SavePlanAction implements Action {
  @Override
  public String execute(HttpServletRequest request, HttpServletResponse response) throws IOException {
    try {
      BufferedReader reader = request.getReader();
      StringBuilder sb = new StringBuilder();
      String line;
      while ((line = reader.readLine()) != null) {
        sb.append(line);
      }

      String requestBody = sb.toString();
      System.out.println("📩 Received Request: " + requestBody);

      JSONObject requestData = new JSONObject(requestBody);
      System.out.println("📄 Parsed JSON: " + requestData.toString());

      PlanVO plan = new PlanVO();
      plan.setUser_idx(requestData.getString("user_idx"));
      plan.setArea_code(requestData.getString("area_code"));
      plan.setTitle(requestData.getString("title"));
      plan.setStart_date(requestData.getString("start_date"));
      plan.setEnd_date(requestData.getString("end_date"));
      plan.setStatus("0"); // Default active

      int planIdx = PlanDAO.insertPlan(plan);
      if (planIdx == -1) {
        System.out.println("Failed to save plan");
        request.setAttribute("jsonResponseText", new Gson().toJson("{\"success\":\"false\"}"));
        return "/planning2.jsp";
      }

      JSONObject dates = requestData.getJSONObject("dates");
      System.out.println("📅 Dates JSON: " + dates.toString());

      for (String dateKey : dates.keySet()) {
        int dateIdx = PlanDAO.insertDate(planIdx, dateKey);
        System.out.println("📝 Inserting date: " + dateKey + " (dateIdx: " + dateIdx + ")");
        if (dateIdx == -1) {
          System.out.println("Filed to save date: " + dateKey);
          request.setAttribute("jsonResponseText", new Gson().toJson("{\"success\":\"false\"}"));
          return "/planning2.jsp";
        }

        JSONArray places = dates.getJSONArray(dateKey);
        for (int i = 0; i < places.length(); i++) {
          JSONObject place = places.getJSONObject(i);
          boolean success = PlanDAO.insertPlace(dateIdx, i + 1, place);
          if (!success) {
            System.out.println("Failed to save place: " + place.getString("title"));
            request.setAttribute("jsonResponseText", new Gson().toJson("{\"success\":\"false\"}"));
            return "/planning2.jsp";
          }
        }
      }

      request.setAttribute("jsonResponseText", new Gson().toJson("{\"success\":\"true\"}"));
      return "/planning2.jsp";
    } catch (Exception e) {
      e.printStackTrace();
      System.err.println("❌ Server Exception: " + e.getMessage());
      System.out.println("Internal server error: " + e.getMessage());
      request.setAttribute("jsonResponseText", new Gson().toJson("{\"success\":\"false\"}"));
      return "/planning2.jsp";
    }
  }
  // json responseText(true/false )
  //return jsonResponse >> return "/planning2.jsp/
}
