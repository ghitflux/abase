#!/usr/bin/env python
"""
Sistema de versionamento automático para ABASE
Gerencia commits e push para GitHub de forma segura
"""

import os
import sys
import subprocess
import json
from pathlib import Path
from datetime import datetime
from typing import List, Tuple, Optional

class Color:
    """Cores para output no terminal"""
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    MAGENTA = '\033[95m'
    CYAN = '\033[96m'
    WHITE = '\033[97m'
    END = '\033[0m'
    BOLD = '\033[1m'

class GitManager:
    """Gerenciador de Git para o projeto ABASE"""
    
    def __init__(self):
        self.project_root = Path(__file__).parent.parent
        self.protected_files = [
            '.env',
            'core/settings.py',  # Se contém credenciais
            '**/*.key',
            '**/*.pem',
            '**/*.p12',
            '**/secrets.json'
        ]
        
    def print_header(self, message: str):
        """Imprime cabeçalho formatado"""
        print(f"\n{Color.BOLD}{Color.BLUE}{'='*60}{Color.END}")
        print(f"{Color.BOLD}{Color.BLUE}  {message}{Color.END}")
        print(f"{Color.BOLD}{Color.BLUE}{'='*60}{Color.END}\n")
        
    def print_success(self, message: str):
        """Imprime mensagem de sucesso"""
        print(f"{Color.GREEN}✓ {message}{Color.END}")
        
    def print_error(self, message: str):
        """Imprime mensagem de erro"""
        print(f"{Color.RED}✗ {message}{Color.END}")
        
    def print_warning(self, message: str):
        """Imprime mensagem de aviso"""
        print(f"{Color.YELLOW}⚠ {message}{Color.END}")
        
    def print_info(self, message: str):
        """Imprime mensagem informativa"""
        print(f"{Color.CYAN}ℹ {message}{Color.END}")
    
    def run_command(self, command: List[str], capture_output: bool = False) -> Tuple[bool, Optional[str]]:
        """
        Executa comando git e retorna resultado
        
        Args:
            command: Lista com comando e argumentos
            capture_output: Se deve capturar output
            
        Returns:
            Tupla (sucesso, output)
        """
        try:
            if capture_output:
                result = subprocess.run(
                    command,
                    cwd=self.project_root,
                    capture_output=True,
                    text=True,
                    check=True
                )
                return True, result.stdout.strip()
            else:
                subprocess.run(
                    command,
                    cwd=self.project_root,
                    check=True
                )
                return True, None
        except subprocess.CalledProcessError as e:
            if capture_output and e.stdout:
                print(f"STDOUT: {e.stdout}")
            if capture_output and e.stderr:
                print(f"STDERR: {e.stderr}")
            return False, None
        except Exception as e:
            print(f"Erro: {str(e)}")
            return False, None
    
    def check_git_status(self) -> Tuple[bool, List[str], List[str]]:
        """
        Verifica status do repositório git
        
        Returns:
            Tupla (repo_limpo, arquivos_modificados, arquivos_nao_rastreados)
        """
        success, output = self.run_command(['git', 'status', '--porcelain'], capture_output=True)
        
        if not success:
            return False, [], []
        
        if not output:
            return True, [], []
        
        modified = []
        untracked = []
        
        for line in output.split('\n'):
            if line.strip():
                status = line[:2]
                filename = line[3:].strip()
                
                if status.startswith('??'):
                    untracked.append(filename)
                else:
                    modified.append(filename)
        
        return False, modified, untracked
    
    def check_protected_files(self, files: List[str]) -> List[str]:
        """
        Verifica se algum arquivo protegido será commitado
        
        Args:
            files: Lista de arquivos para verificar
            
        Returns:
            Lista de arquivos protegidos encontrados
        """
        protected_found = []
        
        for file_path in files:
            # Verificar arquivos específicos
            if any(file_path.endswith(protected) for protected in ['.env', 'secrets.json']):
                protected_found.append(file_path)
                continue
            
            # Verificar padrões
            if any(file_path.endswith(ext) for ext in ['.key', '.pem', '.p12']):
                protected_found.append(file_path)
                continue
            
            # Verificar conteúdo de arquivos Python para credenciais
            if file_path.endswith('.py'):
                try:
                    full_path = self.project_root / file_path
                    if full_path.exists():
                        with open(full_path, 'r', encoding='utf-8') as f:
                            content = f.read()
                            
                        # Padrões suspeitos
                        suspicious_patterns = [
                            'password =',
                            'secret_key =',
                            'api_key =',
                            'token =',
                            'aws_secret',
                            'database_url =',
                        ]
                        
                        for pattern in suspicious_patterns:
                            if pattern.lower() in content.lower():
                                # Verificar se não está usando config() ou environ
                                lines_with_pattern = [
                                    line.strip() for line in content.split('\n')
                                    if pattern.lower() in line.lower()
                                ]
                                
                                for line in lines_with_pattern:
                                    if 'config(' not in line and 'environ' not in line and not line.startswith('#'):
                                        protected_found.append(f"{file_path} (possível credencial hardcoded)")
                                        break
                except Exception:
                    pass  # Ignora erro ao ler arquivo
        
        return protected_found
    
    def create_gitignore_if_needed(self):
        """Cria ou atualiza .gitignore com padrões seguros"""
        gitignore_path = self.project_root / '.gitignore'
        
        essential_patterns = [
            '# Ambiente',
            '.env',
            '.env.*',
            '!.env.example',
            '',
            '# Python',
            '__pycache__/',
            '*.py[cod]',
            '*$py.class',
            '*.so',
            '.Python',
            'env/',
            'venv/',
            '.venv/',
            '',
            '# Django',
            '*.log',
            'local_settings.py',
            'db.sqlite3',
            'media/',
            'staticfiles/',
            '',
            '# Node.js',
            'node_modules/',
            'npm-debug.log*',
            '',
            '# IDE',
            '.vscode/',
            '.idea/',
            '*.swp',
            '*.swo',
            '',
            '# Sistema',
            '.DS_Store',
            'Thumbs.db',
            '',
            '# Credenciais',
            '*.key',
            '*.pem',
            '*.p12',
            'secrets.json',
            'credentials.json',
            '',
            '# Relatórios',
            'htmlcov/',
            '.coverage',
            '.pytest_cache/',
            '',
            '# Build',
            'dist/',
            'build/',
            '*.egg-info/'
        ]
        
        if gitignore_path.exists():
            with open(gitignore_path, 'r', encoding='utf-8') as f:
                existing_content = f.read()
        else:
            existing_content = ''
        
        # Adicionar padrões que não existem
        patterns_to_add = []
        for pattern in essential_patterns:
            if pattern and pattern not in existing_content:
                patterns_to_add.append(pattern)
        
        if patterns_to_add:
            with open(gitignore_path, 'a', encoding='utf-8') as f:
                f.write('\n# Padrões adicionados automaticamente\n')
                for pattern in patterns_to_add:
                    f.write(f"{pattern}\n")
            
            self.print_info(f"Adicionados {len(patterns_to_add)} padrões ao .gitignore")
    
    def run_tests_before_commit(self) -> bool:
        """Executa testes antes do commit"""
        self.print_info("Executando testes automatizados...")
        
        test_script = self.project_root / 'scripts' / 'test_runner.py'
        if not test_script.exists():
            self.print_warning("Script de testes não encontrado, pulando testes")
            return True
        
        try:
            result = subprocess.run(
                [sys.executable, str(test_script)],
                cwd=self.project_root,
                capture_output=True,
                text=True
            )
            
            if result.returncode == 0:
                self.print_success("Testes passaram com sucesso")
                return True
            else:
                self.print_error("Alguns testes falharam")
                print("Output dos testes:")
                print(result.stdout)
                if result.stderr:
                    print("Erros:")
                    print(result.stderr)
                return False
                
        except Exception as e:
            self.print_warning(f"Erro ao executar testes: {str(e)}")
            return True  # Não bloquear commit por erro no teste
    
    def create_commit(self, message: str, files: List[str] = None) -> bool:
        """
        Cria commit com mensagem especificada
        
        Args:
            message: Mensagem do commit
            files: Lista de arquivos específicos (None para todos)
            
        Returns:
            True se commit foi criado com sucesso
        """
        # Adicionar arquivos
        if files:
            for file_path in files:
                success, _ = self.run_command(['git', 'add', file_path])
                if not success:
                    self.print_error(f"Falha ao adicionar {file_path}")
                    return False
        else:
            success, _ = self.run_command(['git', 'add', '.'])
            if not success:
                self.print_error("Falha ao adicionar arquivos")
                return False
        
        # Criar commit com mensagem formatada
        full_message = f"{message}\n\n🤖 Generated with Claude Code\n\nCo-Authored-By: Claude <noreply@anthropic.com>"
        
        success, _ = self.run_command(['git', 'commit', '-m', full_message])
        if success:
            self.print_success("Commit criado com sucesso")
            return True
        else:
            self.print_error("Falha ao criar commit")
            return False
    
    def push_to_remote(self, branch: str = None) -> bool:
        """
        Faz push para o repositório remoto
        
        Args:
            branch: Nome do branch (None para branch atual)
            
        Returns:
            True se push foi bem-sucedido
        """
        # Descobrir branch atual se não especificado
        if branch is None:
            success, branch = self.run_command(['git', 'rev-parse', '--abbrev-ref', 'HEAD'], capture_output=True)
            if not success:
                self.print_error("Não foi possível determinar branch atual")
                return False
        
        # Verificar se existe remote
        success, remotes = self.run_command(['git', 'remote'], capture_output=True)
        if not success or not remotes:
            self.print_error("Nenhum remote configurado")
            return False
        
        # Fazer push
        success, _ = self.run_command(['git', 'push', 'origin', branch])
        if success:
            self.print_success(f"Push para origin/{branch} realizado com sucesso")
            return True
        else:
            self.print_error("Falha no push")
            return False
    
    def interactive_commit_and_push(self):
        """Interface interativa para commit e push"""
        self.print_header("SISTEMA DE VERSIONAMENTO ABASE")
        
        # Verificar se estamos em um repositório git
        if not (self.project_root / '.git').exists():
            self.print_error("Não é um repositório git. Execute 'git init' primeiro.")
            return False
        
        # Atualizar .gitignore
        self.create_gitignore_if_needed()
        
        # Verificar status
        repo_clean, modified, untracked = self.check_git_status()
        
        if repo_clean:
            self.print_info("Repositório está limpo, nada para commitar")
            return True
        
        # Mostrar arquivos modificados
        all_files = modified + untracked
        
        print("\nArquivos modificados/novos:")
        for i, file_path in enumerate(all_files, 1):
            status = "M" if file_path in modified else "??"
            print(f"  {i:2}. [{status}] {file_path}")
        
        # Verificar arquivos protegidos
        protected = self.check_protected_files(all_files)
        if protected:
            self.print_error("ATENÇÃO: Arquivos protegidos detectados!")
            for file_path in protected:
                print(f"  ⚠ {file_path}")
            
            response = input(f"\n{Color.YELLOW}Deseja continuar mesmo assim? (y/N): {Color.END}").lower()
            if response != 'y':
                self.print_info("Operação cancelada pelo usuário")
                return False
        
        # Solicitar mensagem de commit
        print(f"\n{Color.CYAN}Digite a mensagem do commit:{Color.END}")
        print("Exemplos:")
        print("  feat: adicionar sistema de upload")
        print("  fix: corrigir erro de validação")
        print("  docs: atualizar documentação")
        print("  refactor: reorganizar código de autenticação")
        
        commit_message = input("\nMensagem: ").strip()
        
        if not commit_message:
            self.print_error("Mensagem de commit não pode estar vazia")
            return False
        
        # Perguntar se deve executar testes
        run_tests = input(f"\n{Color.CYAN}Executar testes antes do commit? (Y/n): {Color.END}").lower()
        if run_tests != 'n':
            if not self.run_tests_before_commit():
                response = input(f"\n{Color.YELLOW}Testes falharam. Continuar mesmo assim? (y/N): {Color.END}").lower()
                if response != 'y':
                    self.print_info("Commit cancelado devido a falhas nos testes")
                    return False
        
        # Criar commit
        if not self.create_commit(commit_message):
            return False
        
        # Perguntar sobre push
        should_push = input(f"\n{Color.CYAN}Fazer push para o GitHub? (Y/n): {Color.END}").lower()
        if should_push != 'n':
            return self.push_to_remote()
        
        self.print_success("Commit criado localmente (não enviado para GitHub)")
        return True
    
    def quick_commit_push(self, message: str, skip_tests: bool = False):
        """
        Commit e push rápidos com mensagem
        
        Args:
            message: Mensagem do commit
            skip_tests: Se deve pular testes
        """
        self.print_header("COMMIT E PUSH RÁPIDOS")
        
        # Verificar status
        repo_clean, modified, untracked = self.check_git_status()
        
        if repo_clean:
            self.print_info("Repositório limpo, nada para commitar")
            return True
        
        all_files = modified + untracked
        
        # Verificar arquivos protegidos
        protected = self.check_protected_files(all_files)
        if protected:
            self.print_error("Arquivos protegidos detectados, use modo interativo")
            return False
        
        # Executar testes se solicitado
        if not skip_tests:
            if not self.run_tests_before_commit():
                self.print_error("Testes falharam, commit cancelado")
                return False
        
        # Commit e push
        if self.create_commit(message):
            return self.push_to_remote()
        
        return False

def main():
    """Função principal"""
    git_manager = GitManager()
    
    if len(sys.argv) < 2:
        # Modo interativo
        git_manager.interactive_commit_and_push()
    else:
        command = sys.argv[1]
        
        if command == 'quick':
            if len(sys.argv) < 3:
                print("Uso: python git_manager.py quick \"mensagem do commit\"")
                sys.exit(1)
            
            message = sys.argv[2]
            skip_tests = '--skip-tests' in sys.argv
            
            git_manager.quick_commit_push(message, skip_tests)
        
        elif command == 'status':
            repo_clean, modified, untracked = git_manager.check_git_status()
            
            if repo_clean:
                git_manager.print_success("Repositório limpo")
            else:
                print(f"Modificados: {len(modified)}")
                print(f"Não rastreados: {len(untracked)}")
        
        else:
            print("Comandos disponíveis:")
            print("  python git_manager.py                    # Modo interativo")
            print("  python git_manager.py quick \"mensagem\"   # Commit e push rápidos")
            print("  python git_manager.py status             # Verificar status")

if __name__ == '__main__':
    main()