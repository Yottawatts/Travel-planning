package mybatis.vo;

import java.util.List;

public class PlanVO {
  private String idx, user_idx, area_code, title, start_date, end_date, status, date_idx;
  private List<DateVO> dateList; // added field

  public List<DateVO> getDateList() {
    return dateList;
  }

  public void setDateList(List<DateVO> dateList) {
    this.dateList = dateList;
  }

  public String getIdx() {
    return idx;
  }

  public void setIdx(String idx) {
    this.idx = idx;
  }

  public String getUser_idx() {
    return user_idx;
  }

  public void setUser_idx(String user_idx) {
    this.user_idx = user_idx;
  }

  public String getArea_code() {
    return area_code;
  }

  public void setArea_code(String area_code) {
    this.area_code = area_code;
  }

  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public String getStart_date() {
    return start_date;
  }

  public void setStart_date(String start_date) {
    this.start_date = start_date;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public String getEnd_date() {
    return end_date;
  }

  public void setEnd_date(String end_date) {
    this.end_date = end_date;
  }

  public String getDate_idx() {
    return date_idx;
  }
  public void setDate_idx(String date_idx) {}
}
