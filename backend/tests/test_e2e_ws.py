import asyncio
import json
import websockets
import pytest

@pytest.mark.asyncio
async def test_live_game_simulation():
    uri = "ws://127.0.0.1:8000/ws/game"
    try:
        ws_cm = websockets.connect(uri)
        ws = await ws_cm.__aenter__()
    except (OSError, Exception):
        pytest.skip("FastAPI live server is not running on 127.0.0.1:8000")

    try:
        # Receive initial state
        initial_msg = await ws.recv()
        initial_data = json.loads(initial_msg)
        print("Connected! Initial status:", initial_data.get("state", {}).get("status"))

        # Trigger single step move
        import httpx
        async with httpx.AsyncClient() as client:
            res = await client.post("http://127.0.0.1:8000/api/game/control", json={"action": "step"})
            print("Step triggered:", res.json()["status"])

        # Listen for thinking chunks and move made
        chunks_count = 0
        move_received = None

        while True:
            msg = await asyncio.wait_for(ws.recv(), timeout=10.0)
            data = json.loads(msg)
            msg_type = data.get("type")
            
            if msg_type == "thinking_chunk":
                chunks_count += 1
            elif msg_type == "move_made":
                move_received = data.get("move", {})
                print(f"[SUCCESS] Received move event: {move_received.get('san')} by {move_received.get('player_name')}")
                print(f"Reasoning snippet: {move_received.get('reasoning')[:80]}...")
                break

        print(f"Total thinking chunks streamed: {chunks_count}")
        assert move_received is not None
        assert move_received["san"] in ["e4", "d4", "Nf3", "c4", "g3", "b3", "Nc3", "f4", "e3", "d3"]
        print("End-to-end WebSocket simulation test PASSED!")
    finally:
        await ws_cm.__aexit__(None, None, None)

if __name__ == "__main__":
    asyncio.run(test_live_game_simulation())
