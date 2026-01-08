package com.todoapp.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class TodoRequest {
    private String title;
    private String description;
    private Boolean completed;
    private Integer priority;
    private LocalDateTime dueDate;
}

