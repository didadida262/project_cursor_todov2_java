package com.todoapp.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ApiResponse<T> {
    private Integer code;
    private String message;
    private T data;
    private Long total;

    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(200, "success", data, null);
    }

    public static <T> ApiResponse<T> success(T data, Long total) {
        return new ApiResponse<>(200, "success", data, total);
    }

    public static <T> ApiResponse<T> created(T data) {
        return new ApiResponse<>(201, "Todo created successfully", data, null);
    }

    public static <T> ApiResponse<T> error(Integer code, String message) {
        return new ApiResponse<>(code, message, null, null);
    }
}

