package com.webs.furniturewebs.repository;

import com.webs.furniturewebs.entity.ProductOffer;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ProductOfferRepository extends JpaRepository<ProductOffer, Integer> {
    List<ProductOffer> findByOffer_OfferId(Integer offerId);
    List<ProductOffer> findByProduct_ProductId(Integer productId);
}