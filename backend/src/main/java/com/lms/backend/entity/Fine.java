package com.lms.backend.entity;

import com.lms.backend.enums.FineStatus;
import jakarta.persistence.*;
import lombok.Data;

import java.math.BigDecimal;

@Entity
@Table(name = "fines")
@Data
public class Fine {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private BigDecimal amount;
    private String reason;

    @Enumerated(EnumType.STRING)
    private FineStatus status;

    @ManyToOne
    @JoinColumn(name = "loan_slip_id")
    private LoanSlip loanSlip;

    @ManyToOne
    @JoinColumn(name = "payment_id")
    private Payment payment;
}