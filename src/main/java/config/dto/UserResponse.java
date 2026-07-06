package com.webs.furniturewebs.dto;

import com.webs.furniturewebs.entity.Role;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserResponse {
    private Integer userId;
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private Role role;
    private Boolean isVerified;
    private String preferredLanguage;
    private Boolean languageSelected;
    private String authProvider;
}