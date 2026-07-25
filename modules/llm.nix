_: {
  flake.modules.homeManager.llm = { pkgs, ... }: {
    home.packages = with pkgs; [
      # gpt4all         # LLM interface
      ollama # LLM manager
      claude-code
    ];
  };
}
