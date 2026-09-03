package com.dentalclinic.dto;

public class TimeSlotDTO {

    private String time;
    private String formattedTime;
    private boolean available;
    private String reason;

    public TimeSlotDTO() {
    }

    public TimeSlotDTO(String time, String formattedTime, boolean available, String reason) {
        this.time = time;
        this.formattedTime = formattedTime;
        this.available = available;
        this.reason = reason;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getFormattedTime() {
        return formattedTime;
    }

    public void setFormattedTime(String formattedTime) {
        this.formattedTime = formattedTime;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }
}
