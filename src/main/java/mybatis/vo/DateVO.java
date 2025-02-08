package mybatis.vo;

public class DateVO {
  private int idx, plan_idx;
  private String date, memo;

  public int getIdx() { return idx; }
  public void setIdx(int idx) { this.idx = idx; }

  public int getPlan_idx() { return plan_idx; }
  public void setPlan_idx(int plan_idx) { this.plan_idx = plan_idx; }

  public String getDate() { return date; }
  public void setDate(String date) { this.date = date; }

  public String getMemo() { return memo; }
  public void setMemo(String memo) { this.memo = memo; }
}
