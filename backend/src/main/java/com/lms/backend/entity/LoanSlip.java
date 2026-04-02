package com.lms.backend.entity;

import com.lms.backend.enums.LoanStatus;
import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "loan_slips")

public class LoanSlip {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "borrow_date")
    private LocalDateTime borrowDate;

    @Column(name = "due_date")
    private LocalDateTime dueDate;

    @Column(name = "return_date")
    private LocalDateTime returnDate;

    @Enumerated(EnumType.STRING)
    private LoanStatus status;

    @ManyToOne
    @JoinColumn(name = "card_id")
    private LibraryCard libraryCard;

    @OneToMany
    @JoinColumn(name = "loan_slip_id") // Liên kết trực tiếp sang bảng Edition
    private List<Edition> editions;
}