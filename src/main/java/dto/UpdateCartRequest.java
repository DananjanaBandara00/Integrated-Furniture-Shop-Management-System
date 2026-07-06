package com.webs.furniturewebs.dto;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class UpdateCartRequest {
    private Integer productId;
    private Integer quantity;   // if <= 0 → will be treated as remove
}