package com.webs.furniturewebs.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "saved_cards")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SavedCard {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer cardId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String cardToken;

    private String last4;           // e.g. "4242"

    private String cardType;        // VISA, MASTERCARD, etc.

    private String cardHolderName;

    private String expiryDate;      // MM/YY

    @Column(name = "masked_number")
    private String maskedNumber;    // e.g. "**** **** **** 4242"

    // Custom constructor (kept for backward compatibility)
    public SavedCard(User user, String cardToken, String last4, String cardType,
                     String cardHolderName, String expiryDate) {
        this.user = user;
        this.cardToken = cardToken;
        this.last4 = last4;
        this.cardType = cardType;
        this.cardHolderName = cardHolderName;
        this.expiryDate = expiryDate;
        this.maskedNumber = "**** **** **** " + (last4 != null ? last4 : "****");
    }

    // Better setter for last4 that automatically generates maskedNumber
    public void setLast4(String last4) {
        this.last4 = last4;
        if (last4 != null && last4.length() >= 4) {
            this.maskedNumber = "**** **** **** " + last4;
        } else {
            this.maskedNumber = "**** **** **** ****";
        }
    }

    // Helper method (optional but useful)
    public String getDisplayName() {
        return (cardType != null ? cardType + " " : "") +
                (maskedNumber != null ? maskedNumber : "**** **** **** " + last4);
    }
}