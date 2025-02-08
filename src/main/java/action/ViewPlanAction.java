package action;

import mybatis.dao.PlanDAO;
import mybatis.vo.PlanVO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ViewPlanAction implements Action {
  @Override
  public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
    String planIdStr = request.getParameter("planId");
    if(planIdStr == null || planIdStr.isEmpty()){
      return "/error.jsp";
    }
    int planId = Integer.parseInt(planIdStr);
    PlanVO plan = PlanDAO.getPlanById(planId);
    if(plan == null){
      return "/notFound.jsp";
    }
    request.setAttribute("plan", plan);
    // The JSP will compare the plan’s owner with the logged-in user.
    return "/view_plan.jsp";
  }
}
