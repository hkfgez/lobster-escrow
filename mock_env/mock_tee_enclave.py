# mock_env/mock_tee_enclave.py
import time
import json
import hashlib

print("==================================================")
print("[DEV-MODE] Initializing Software TEE Simulation...")
print("[WARN] Hardware SGX not detected. Running Mock Enclave.")
print("==================================================")

def generate_mock_dcap_quote(payload: dict):
    """
    Simulates the generation of an Automata DCAP Quote and zkTLS proof.
    In a real environment, this happens inside the Intel SGX enclave.
    """
    print("> [Mock Enclave] Receiving B2B transaction payload...")
    time.sleep(1) # Simulate hardware latency
    
    # Generate a fake cryptographic hash and signature
    raw_data = json.dumps(payload, sort_keys=True).encode()
    fake_hash = hashlib.sha256(raw_data).hexdigest()
    
    print(f"> [Mock Enclave] Generating fake zkTLS Proof for hash: {fake_hash[:16]}...")
    time.sleep(1.5)
    
    mock_proof = {
        "status": "ATTESTED_DEV_MODE",
        "quote_hash": fake_hash,
        "zkTLS_signature": f"0x_mock_sig_{fake_hash[:20]}",
        "is_hardware_backed": False
    }
    
    print("> [Mock Enclave] Proof generated successfully. Ready for Onchain validation.")
    return mock_proof

if __name__ == "__main__":
    # Test the mock
    dummy_payload = {"agent_a": "0x123", "agent_b": "0x456", "action": "deliver_data"}
    result = generate_mock_dcap_quote(dummy_payload)
    print(json.dumps(result, indent=2))
