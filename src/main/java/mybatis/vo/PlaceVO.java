package mybatis.vo;

public class PlaceVO {
  private String idx, date_idx, visit_order, content_id, content_type_id, title, thumbnail, map_x, map_y, time;


  public String getContent_id() {
    return content_id;
  }

  public void setContent_id(String content_id) {
    this.content_id = content_id;
  }

  public String getThumbnail() {
    return thumbnail;
  }

  public void setThumbnail(String thumbnail) {
    this.thumbnail = thumbnail;
  }

  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public String getTime() {
    return time;
  }

  public void setTime(String time) {
    this.time = time;
  }

  public String getIdx() {
    return idx;
  }

  public void setIdx(String idx) {
    this.idx = idx;
  }

  public String getDate_idx() {
    return date_idx;
  }

  public void setDate_idx(String date_idx) {
    this.date_idx = date_idx;
  }

  public String getVisit_order() {
    return visit_order;
  }

  public void setVisit_order(String visit_order) {
    this.visit_order = visit_order;
  }

  public String getContent_type_id() {
    return content_type_id;
  }

  public void setContent_type_id(String content_type_id) {
    this.content_type_id = content_type_id;
  }

  public String getMap_x() {
    return map_x;
  }

  public void setMap_x(String map_x) {
    this.map_x = map_x;
  }

  public String getMap_y() {
    return map_y;
  }

  public void setMap_y(String map_y) {
    this.map_y = map_y;
  }
}
