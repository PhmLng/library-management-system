package com.lms.backend.entity;

import com.lms.backend.enums.RenewalStatus;
import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Entity
@Table(name = "renewals")
@Data
public class Renewal {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "request_date")
    private LocalDateTime requestDate;

    @Column(name = "new_date", nullable = false)
    private LocalDateTime newDate;

    @Enumerated(EnumType.STRING)
    private RenewalStatus status;

    // Nhiều lần gia hạn có thể thuộc về cùng 1 phiếu mượn
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "loan_slip_id")
    private LoanSlip loanSlip;
}
