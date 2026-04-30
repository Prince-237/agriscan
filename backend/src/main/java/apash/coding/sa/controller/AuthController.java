package apash.coding.sa.controller;

import apash.coding.sa.dto.AuthResponse;
import apash.coding.sa.dto.LoginRequest;
import apash.coding.sa.dto.RegisterRequest;
import apash.coding.sa.entites.Client;
import apash.coding.sa.service.AuthService;
import apash.coding.sa.service.ClientService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*") // autorise Flutter à appeler le backend
public class AuthController {

    private final AuthService authService;
    private final ClientService clientService;

    public AuthController(AuthService authService, ClientService clientService) {
        this.authService = authService;
        this.clientService = clientService;
    }

    // POST /api/auth/register
   @PostMapping("/register")
public ResponseEntity<?> register(@RequestBody RegisterRequest request) {

    try {
        AuthResponse response = authService.register(
            request.getName(),
            request.getEmail(),
            request.getTelephone(),
            request.getProfil(),
            request.getPassword()
        );

        return ResponseEntity.ok(response);

    } catch (RuntimeException e) {
        return ResponseEntity.badRequest().body(e.getMessage());
    }
}

    // POST /api/auth/login
    @PostMapping("/login")
public ResponseEntity<?> login(@RequestBody LoginRequest request) {

    try {
        AuthResponse response = authService.login(
            request.getEmail(),
            request.getPassword()
        );

        return ResponseEntity.ok(response);

    } catch (RuntimeException e) {
        return ResponseEntity.badRequest().body(e.getMessage());
    }
}
}