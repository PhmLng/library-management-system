package com.lms.backend.entity;

import com.lms.backend.enums.EditionStatus;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "editions")
@Data
public class Edition {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true)
    private String barcode;

    private String location;

    @Enumerated(EnumType.STRING)
    private EditionStatus status;

    @ManyToOne
    @JoinColumn(name = "book_id")
    private Book book;
}