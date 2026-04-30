package apash.coding.sa.service;

import apash.coding.sa.dto.AuthResponse;
import apash.coding.sa.entites.Client;
import apash.coding.sa.repository.ClientRepository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final ClientRepository clientRepository;
    private final BCryptPasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthService(ClientRepository clientRepository,
                       BCryptPasswordEncoder passwordEncoder,
                       JwtService jwtService) {
        this.clientRepository = clientRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    // ── Register ──────────────────────────────────────────────
    public AuthResponse register(String name, String email,
                             String telephone, String profil,
                             String rawPassword) {

    if (clientRepository.existsByEmail(email)) {
        throw new RuntimeException("Email déjà utilisé");
    }

    Client client = new Client(
        name,
        email,
        telephone,
        profil,
        passwordEncoder.encode(rawPassword)
    );

    clientRepository.save(client);

    String token = jwtService.generateToken(email);

    return new AuthResponse(
        client.getId(),
        token,
        client.getEmail(),
        client.getName()
    );
}

    // ── Login ─────────────────────────────────────────────────
   public AuthResponse login(String email, String rawPassword) {

    Client client = clientRepository.findByEmail(email)
        .orElseThrow(() -> new RuntimeException("Utilisateur introuvable"));

    if (!passwordEncoder.matches(rawPassword, client.getPassword())) {
        throw new RuntimeException("Mot de passe incorrect");
    }

    String token = jwtService.generateToken(email);

    return new AuthResponse(
        client.getId(),
        token,
        client.getEmail(),
        client.getName()
    );
}
}