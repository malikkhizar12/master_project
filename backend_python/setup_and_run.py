"""
Complete setup script: Create data, clean, train models, and run API
"""
import subprocess
import sys
import os

def run_command(command, description):
    """Run a command and handle errors"""
    print(f"\n{'='*60}")
    print(f"[*] {description}")
    print(f"{'='*60}\n")
    
    try:
        result = subprocess.run(
            command,
            shell=True,
            check=True,
            capture_output=False
        )
        print(f"[OK] {description} completed successfully\n")
        return True
    except subprocess.CalledProcessError as e:
        print(f"[ERROR] Error in {description}: {e}\n")
        return False

def main():
    """Main setup function"""
    import sys
    import io
    # Fix encoding for Windows console
    if sys.platform == 'win32':
        sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
    
    print("\n" + "="*60)
    print("Focus Learning Backend - Complete Setup")
    print("="*60)
    
    # Create directories
    os.makedirs('data', exist_ok=True)
    os.makedirs('models', exist_ok=True)
    
    steps = [
        ("python create_dummy_data.py", "Creating dummy datasets"),
        ("python clean_data.py", "Cleaning datasets"),
        ("python train_model.py", "Training recommendation models"),
    ]
    
    # Run setup steps
    for command, description in steps:
        if not run_command(command, description):
            print(f"[ERROR] Setup failed at: {description}")
            print("Please check the error above and try again.")
            sys.exit(1)
    
    print("\n" + "="*60)
    print("[OK] Setup completed successfully!")
    print("="*60)
    print("\nNext steps:")
    print("   1. Run the API server: python main.py")
    print("   2. Or use: uvicorn main:app --reload --host 0.0.0.0 --port 8000")
    print("   3. API will be available at: http://localhost:8000")
    print("   4. API docs at: http://localhost:8000/docs")
    print("\n")

if __name__ == "__main__":
    main()

