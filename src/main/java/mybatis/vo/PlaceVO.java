package mybatis.vo;

public class PlaceVO {
  private int idx, date_idx, visit_order, content_type_id;
  private String content_id, title, thumbnail, time;
  private double map_x, map_y;

  public int getIdx() { return idx; }
  public void setIdx(int idx) { this.idx = idx; }

  public int getDate_idx() { return date_idx; }
  public void setDate_idx(int date_idx) { this.date_idx = date_idx; }

  public int getVisit_order() { return visit_order; }
  public void setVisit_order(int visit_order) { this.visit_order = visit_order; }

  public String getContent_id() { return content_id; }
  public void setContent_id(String content_id) { this.content_id = content_id; }

  public int getContent_type_id() { return content_type_id; }
  public void setContent_type_id(int content_type_id) { this.content_type_id = content_type_id; }

  public String getTitle() { return title; }
  public void setTitle(String title) { this.title = title; }

  public String getThumbnail() { return thumbnail; }
  public void setThumbnail(String thumbnail) { this.thumbnail = thumbnail; }

  public double getMap_x() { return map_x; }
  public void setMap_x(double map_x) { this.map_x = map_x; }

  public double getMap_y() { return map_y; }
  public void setMap_y(double map_y) { this.map_y = map_y; }

  public String getTime() { return time; }
  public void setTime(String time) { this.time = time; }
}
