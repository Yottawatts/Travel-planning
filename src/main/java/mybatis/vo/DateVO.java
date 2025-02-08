package mybatis.vo;

import java.util.List;

public class DateVO {
  private String idx, plan_idx, date, memo;
  private List<PlaceVO> placeList;


  public List<PlaceVO> getPlaceList() {
    return placeList;
  }

  public void setPlaceList(List<PlaceVO> placeList) {
    this.placeList = placeList;
  }

  public String getDate() {
    return date;
  }

  public void setDate(String date) {
    this.date = date;
  }

  public String getMemo() {
    return memo;
  }

  public void setMemo(String memo) {
    this.memo = memo;
  }

  public String getIdx() {
    return idx;
  }

  public void setIdx(String idx) {
    this.idx = idx;
  }

  public String getPlan_idx() {
    return plan_idx;
  }

  public void setPlan_idx(String plan_idx) {
    this.plan_idx = plan_idx;
  }
}
