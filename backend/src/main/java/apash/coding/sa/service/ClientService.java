package apash.coding.sa.service;

import apash.coding.sa.entites.Client;
import apash.coding.sa.repository.ClientRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ClientService {

    private final ClientRepository clientRepository;

    public ClientService(ClientRepository clientRepository) {
        this.clientRepository = clientRepository;
    }

    // ── Créer un client (si email pas déjà pris) ──────────────
    public void creer(Client client) {
        Optional<Client> clientDansLaBDD = this.clientRepository.findByEmail(client.getEmail());

        if (clientDansLaBDD.isEmpty()) {          // ✅ isEmpty() sur Optional
            this.clientRepository.save(client);
        } else {
            throw new RuntimeException("Email déjà utilisé : " + client.getEmail());
        }
    }

    // ── Lister tous les clients ───────────────────────────────
    public List<Client> rechercher() {
        return this.clientRepository.findAll();
    }

    // ── Lire un client par ID ─────────────────────────────────
    public Client lire(Integer id) {
        return this.clientRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Client introuvable : id=" + id));
    }

    // ── Lire ou créer ─────────────────────────────────────────
    public Client lireOuCreer(Client clientACreer) {
        Optional<Client> clientDansLaBDD = this.clientRepository
            .findByEmail(clientACreer.getEmail());

        if (clientDansLaBDD.isPresent()) {        // ✅ existe déjà → on le retourne
            return clientDansLaBDD.get();
        }

        return this.clientRepository.save(clientACreer); // ✅ sinon on crée
    }

    // ── Modifier un client ────────────────────────────────────
    public void modifier(Integer id, Client client) {
        Client clientDansLaBDD = this.lire(id);   // lève exception si introuvable

        if (clientDansLaBDD.getId().equals(client.getId())) { // ✅ .equals() pour Integer
            clientDansLaBDD.setEmail(client.getEmail());
            clientDansLaBDD.setTelephone(client.getTelephone());
            clientDansLaBDD.setName(client.getName());
            clientDansLaBDD.setProfil(client.getProfil());
            this.clientRepository.save(clientDansLaBDD);
        }
    }

    // ── Supprimer un client ───────────────────────────────────
    public void supprimer(Integer id) {
        if (!this.clientRepository.existsById(id)) {
            throw new RuntimeException("Client introuvable : id=" + id);
        }
        this.clientRepository.deleteById(id);
    }
}