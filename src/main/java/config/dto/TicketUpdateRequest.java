package com.webs.furniturewebs.dto;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class TicketUpdateRequest {
    private String subject;
    private String message;
    // contactNumber and requestType can be added if you want
}