package com.webs.furniturewebs.controller;

import com.webs.furniturewebs.dto.ReviewRequest;
import com.webs.furniturewebs.entity.User;
import com.webs.furniturewebs.service.ReviewService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.webs.furniturewebs.dto.ReviewResponseForProfile;
import com.webs.furniturewebs.dto.ReviewUpdateRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reviews")
public class ReviewController {

    private final ReviewService reviewService;

    public ReviewController(ReviewService reviewService) {
        this.reviewService = reviewService;
    }

    @PostMapping
    public ResponseEntity<String> addReview(@AuthenticationPrincipal User user,
                                            @RequestBody ReviewRequest req) {
        reviewService.addReview(user, req);
        return ResponseEntity.ok("Review added successfully");
    }

    @GetMapping("/my")
    public ResponseEntity<List<ReviewResponseForProfile>> getMyReviews(@AuthenticationPrincipal User user) {
        if (user == null) {
            return ResponseEntity.status(401).build();
        }
        return ResponseEntity.ok(reviewService.getMyReviews(user));
    }

    @PutMapping("/{reviewId}")
    public ResponseEntity<String> updateReview(
            @AuthenticationPrincipal User user,
            @PathVariable Integer reviewId,
            @Valid @RequestBody ReviewUpdateRequest req) {

        reviewService.updateReview(user, reviewId, req);
        return ResponseEntity.ok("Review updated successfully");
    }

    @DeleteMapping("/{reviewId}")
    public ResponseEntity<String> deleteReview(
            @AuthenticationPrincipal User user,
            @PathVariable Integer reviewId) {

        reviewService.deleteReview(user, reviewId);
        return ResponseEntity.ok("Review deleted successfully");
    }
}