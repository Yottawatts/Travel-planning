package action;

import mybatis.dao.PlanDAO;
import mybatis.vo.PlanVO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ViewPlanAction implements Action {
  @Override
  public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
    String planId = request.getParameter("planId");
    System.out.println(planId);
    if(planId == null || planId.trim().isEmpty()){
      request.setAttribute("error", "Plan id is required.");
      return "error.jsp";
    }
    PlanVO plan = PlanDAO.getPlanById(planId);
    if(plan == null){
      request.setAttribute("error", "Plan not found.");
      return "view_plan.jsp";
    }
    request.setAttribute("plan", plan);
    return "view_plan.jsp";
  }
}