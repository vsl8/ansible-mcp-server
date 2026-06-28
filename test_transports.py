#!/usr/bin/env python3
"""Test script to verify both stdio and SSE transports work"""

import subprocess
import time
import sys
import requests
import json

def test_stdio():
    """Test stdio transport (basic startup test)"""
    print("Testing stdio transport...")
    try:
        proc = subprocess.Popen(
            ["uv", "run", "python", "src/ansible_mcp/server.py"],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        time.sleep(2)
        proc.terminate()
        proc.wait(timeout=5)
        print("✅ stdio transport: Server started successfully")
        return True
    except Exception as e:
        print(f"❌ stdio transport failed: {e}")
        return False

def test_sse():
    """Test SSE transport"""
    print("\nTesting SSE transport...")
    proc = None
    try:
        # Start server
        proc = subprocess.Popen(
            ["uv", "run", "python", "src/ansible_mcp/server.py", 
             "--transport", "sse", "--port", "8001"],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        
        # Wait for server to start
        time.sleep(5)
        
        # Check if process is still running
        if proc.poll() is not None:
            print(f"❌ SSE transport: Process exited unexpectedly")
            return False
        
        # Try to connect to SSE endpoint
        try:
            response = requests.get("http://localhost:8001/sse", timeout=5, stream=True)
            if response.status_code == 200:
                print("✅ SSE transport: Server started and accepting connections")
                return True
            else:
                print(f"❌ SSE transport: Unexpected status code {response.status_code}")
                return False
        except requests.exceptions.ConnectionError:
            print("❌ SSE transport: Could not connect to server")
            return False
            
    except Exception as e:
        print(f"❌ SSE transport failed: {e}")
        return False
    finally:
        if proc:
            proc.terminate()
            try:
                proc.wait(timeout=5)
            except subprocess.TimeoutExpired:
                proc.kill()

def main():
    print("=" * 60)
    print("Ansible MCP Server Transport Tests")
    print("=" * 60)
    
    results = []
    
    # Test stdio
    results.append(("stdio", test_stdio()))
    
    # Test SSE
    results.append(("SSE", test_sse()))
    
    # Summary
    print("\n" + "=" * 60)
    print("Test Summary")
    print("=" * 60)
    for transport, passed in results:
        status = "✅ PASS" if passed else "❌ FAIL"
        print(f"{transport:10s}: {status}")
    
    all_passed = all(result[1] for result in results)
    print("=" * 60)
    
    if all_passed:
        print("\n🎉 All transport tests passed!")
        return 0
    else:
        print("\n⚠️  Some tests failed. See details above.")
        return 1

if __name__ == "__main__":
    sys.exit(main())
