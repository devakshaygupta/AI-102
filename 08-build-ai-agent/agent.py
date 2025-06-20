import os
from pathlib import Path
from dotenv import load_dotenv

from azure.identity import DefaultAzureCredential
from azure.ai.agents import AgentsClient
from azure.ai.agents.models import FilePurpose, CodeInterpreterTool, ListSortOrder, MessageRole


def main():

    try:
        # Clear the console
        os.system('cls' if os.name == 'nt' else 'clear')

        # Load environment variables from .env file
        load_dotenv()

        PROJECT_ENDPOINT = os.getenv("PROJECT_ENDPOINT")
        MODEL_DEPLOYMENT_NAME = os.getenv("MODEL_DEPLOYMENT_NAME")

        # Display the data to be analyzed
        script_dir = Path(__file__).parent  # Get the directory of the script
        file_path = script_dir / 'data.txt'

        with file_path.open('r') as file:
            data = file.read() + "\n"
            print(data)

        # Connect to the Agent client
        agent_client = AgentsClient(
            endpoint=PROJECT_ENDPOINT,
            credential=DefaultAzureCredential
            (exclude_environment_credential=True,
            exclude_managed_identity_credential=True)
        )
        with agent_client:
            # Upload the data file and create a code interpreter tool
            file = agent_client.files.upload_and_poll(
                file_path=file_path, purpose=FilePurpose.AGENTS
            )
            print(f"Uploaded {file.filename}")

            code_interpreter = CodeInterpreterTool(file_ids=[file.id])

            # Check if agent already exists
            agent_name = "data-agent"
            existing_agent = None
            agents = agent_client.list_agents()
            for ag in agents:
                if ag.name == agent_name:
                    existing_agent = ag
                    print(f"Using existing agent: {ag.id}")
                    break

            if existing_agent:
                agent = existing_agent
            else:
                # Define an agent that uses code interpreter tool
                agent = agent_client.create_agent(
                    model=MODEL_DEPLOYMENT_NAME,
                    name=agent_name,
                    instructions="You are an AI agent that analyzes the data in the file that has been uploaded. If the user requests a chart, create it and save it as a .png file.",
                    tools=code_interpreter.definitions,
                    tool_resources=code_interpreter.resources,
                    description="An agent that can analyze data and create charts using a code interpreter tool."
                )
                print(f"Created new agent: {agent.id}")

            # Create a thread for the conversation
            thread = agent_client.threads.create()

            while True:
                # Get input text
                user_prompt = input("Enter a prompt (or type 'quit' to exit): ")
                if user_prompt.lower() == "quit":
                    break
                if len(user_prompt) == 0:
                    print("Please enter a prompt.")
                    continue

                # Send a prompt to the agent
                message = agent_client.messages.create(
                    thread_id=thread.id,
                    role="user",
                    content=user_prompt
                )

                run = agent_client.runs.create_and_process(
                    thread_id=thread.id,
                    agent_id=agent.id,
                )

                # Check the run status for failures
                if run.status == "failed":
                    print(f"Run failed: {run.last_error}")

                # Get the response from the agent
                last_msg = agent_client.messages.get_last_message_text_by_role(
                    thread_id=thread.id,
                    role=MessageRole.AGENT
                )

                if last_msg:
                    print(f"Last Message: {last_msg.text.value}")

        # Get the conversation history
        print("\nConversation Log:\n")
        messages = agent_client.messages.list(
            thread_id=thread.id, order=ListSortOrder.ASCENDING)
        for message in messages:
            if message.text_messages:
                last_msg = message.text_messages[-1]
                print(f"{message.role}: {last_msg.text.value}\n")

        # Get any generated files
        for msg in messages:
            # Save every image file in the message
            for img in msg.image_contents:
                file_id = img.image_file.file_id
                file_name = f"{file_id}_image_file.png"
                agent_client.files.save(file_id=file_id, file_name=file_name)
                print(f"Saved image file to: {Path.cwd() / file_name}")

        agent_client.delete_agent(agent.id)

    except Exception as ex:
        print(ex)

if __name__ == "__main__":
    main()
